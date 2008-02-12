Return-Path: <linux-kernel-owner+w=401wt.eu-S1760382AbYBLGlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760382AbYBLGlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 01:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbYBLGlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 01:41:35 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:22875 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752922AbYBLGle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 01:41:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0Is/B95ox6CejKwBxW+KXHQgWU2mC9G5bRy0Iey7h/dYdNZdSnYbNab7nC2+sl37H4qhHdijGRQrlhy2DnTVRD8C7NNiVyENKNu8C1i1+oeLThOSm+xQcZyViLEzXbDLB35IITdV6kWVrWXGzBbKZmRYsFm/ehBRv4NWfXnAevo=  ;
X-YMail-OSG: .8n9a7cVM1k33t5XqNPxJ6590jICw4TQJ7qL1vnPWOCvoCbxRbTZPepZ8gNcPWzUGRYrc9CNiz6z5crBZxaq0uHmR2vapWm3Q7EdJouh9BYDRZq28t8-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [git pull for -mm] CPU isolation extensions (updated2)
Date: Tue, 12 Feb 2008 17:41:21 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       gregkh@suse.de, Rusty Russell <rusty@rustcorp.com.au>
References: <47B11C45.6060408@qualcomm.com>
In-Reply-To: <47B11C45.6060408@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802121741.22201.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2008 15:10, Max Krasnyansky wrote:

> Rusty - Stop machine.
>    After doing a bunch of testing last three days I actually downgraded
> stop machine changes from [highly experimental] to simply [experimental].
> Pleas see this thread for more info:
> http://marc.info/?l=linux-kernel&m=120243837206248&w=2 Short story is that
> I ran several insmod/rmmod workloads on live multi-core boxes with stop
> machine _completely_ disabled and did no see any issues. Rusty did not get
> a chance to reply yet, I hopping that we'll be able to make "stop machine"
> completely optional for some configurations.

stop machine is used for more than just module loading and unloading.
I don't think you can just disable it.
