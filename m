Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbYCPTqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbYCPTqf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 15:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYCPTq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 15:46:27 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:37940 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752481AbYCPTq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 15:46:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=XZZmyOhYY6jagmWpRkeilUa5ON8qfAeYbNqODDvQyO7HJr4RTiAB1jdz+If3+QOkKHgsiQFVv94Qpz+Wby9SIImZ4daLANpIsItZTUZR3IS9pghGY6xd5WhBibr/+wAQg/AZAx3rghlrB3YhjpHwiC3diJ6exGGj/+IvBcUX2TU=  ;
X-YMail-OSG: gioBOPkVM1kTSzilX.2OTNGJAgWvMm.FPLvkVqumdynGlyEbDN_PFFnZVCv616P4w_0iRAQsOg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
Date: Sun, 16 Mar 2008 11:46:23 -0800
User-Agent: KMail/1.9.6
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
References: <20080316184349.GA28543@khazad-dum.debian.net>
In-Reply-To: <20080316184349.GA28543@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200803161246.23909.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 March 2008, Henrique de Moraes Holschuh wrote:
> Is the use of "if (preempt_count())" to know when to defer led gpio work to
> a workqueue needed?  Shouldn't "if (in_atomic())" be enough?

At this point, I don't know of any such reason.

I remember hunting for the right heuristic, and settling on
that one for reasons that I can't recall now.  They may even
be no longer applicable.
