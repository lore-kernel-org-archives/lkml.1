Return-Path: <linux-kernel-owner+w=401wt.eu-S1757306AbYGHCJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbYGHCJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 22:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbYGHCJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 22:09:03 -0400
Received: from smtp117.mail.mud.yahoo.com ([209.191.84.166]:36671 "HELO
	smtp117.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754964AbYGHCJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 22:09:02 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uHyRvTDkR9Po47hleLTaaqMP6uNOPDIxqPxnAmQbi0CVaaidwgogQaL7b6zFt/KFHMD+BIaOdacUsgcse6uBcagnQmc3+XkEZ+icw/YjJl/K6WXj0b5IiXnZ9ddgSS6umK8UDmI+9tZcRQXvGuxSVh7Ta5jNEuVBCUZ0H/FPkDI=  ;
X-YMail-OSG: n3v9MwIVM1khH4aUVjMmfe31MSX_FXSw0PUwZSCZWD_1psC4.uhGXRY9oZfbMx6e3zRcnNAp4a5cRr03BlNj1th3PiV62NwmNO22h3NpXYggyn811IjRiaf1JD1_CuiljXg-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin with irqs disable
Date: Tue, 8 Jul 2008 12:08:37 +1000
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>, Petr Tesarik <ptesarik@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com> <200807072152.59823.nickpiggin@yahoo.com.au> <48723C9D.8090504@goop.org>
In-Reply-To: <48723C9D.8090504@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807081208.37721.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 July 2008 01:56, Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:
> > Although, you wouldn't need to oversubscribe physical CPUs to hit
> > suboptimal behaviour.
> >
> > Basically, I just ask for performance improvement to be measured
> > with some "realistic" configuration, then it should be easier to
> > justify.
>
> Overcommitting cpus system-wide is pretty common.

(yes, sorry I meant: oversubscribing with a single guest)
