Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896AbXEXPIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbXEXPIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 11:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbXEXPI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 11:08:28 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:18313 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbXEXPI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 11:08:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eCVcm651mDixMXq8LRMqDgn4OI0qn1lTHhnCuBqkNZS+mpNnOs2qFrVfWTUSfo58gDJlEoiXXAhRL/IBwevpWoni3MqfX87hOPX3xpF45ImN3CFK2Nl80RmbKg5xrGCvAVBeZtH6mefcEaDGoLwh0sVH1aWjF4AksCJM4UpEa1E=
Message-ID: <8bd0f97a0705240808v7073f0f7g182fabddc3b3ed97@mail.gmail.com>
Date: Thu, 24 May 2007 11:08:25 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Daniel Newby" <daniel.a.newby@gmail.com>
Subject: Re: how to allow board writers to customize driver behavior (watchdog here)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <ba1ee50c0705240147t3d2ebf43w8cb0335bc7c239e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0705232121j32fcff72hd04b04e37507450e@mail.gmail.com>
	 <20070524052312.GA2447@linux-sh.org>
	 <ba1ee50c0705240147t3d2ebf43w8cb0335bc7c239e4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/07, Daniel Newby <daniel.a.newby@gmail.com> wrote:
> On 5/24/07, Paul Mundt <lethal@linux-sh.org> wrote:
> >  It sounds like your constraining your driver based on terminology.
> > Watchdogs on most embedded platforms support either a 'reset' mode or
> > otherwise act as periodic timers, trying to push both of these
> > functionalities in to a watchdog driver is rather pointless.
> > CONFIG_WATCHDOG implies 'reset' mode by definition.
>
> I agree for a product in the hands of a customer:  let the watchdog
> pull your bacon out of the fire.
>
> But what about debugging?  Suppose your embedded computer with custom
> drivers locks up solid every few hundred hours.  It would be nice if
> the watchdog gave a stack dump instead erasing the evidence.  How about
> having "action=reset" and "action=debug"?

"action" corresponds one to one with the functionality of the hardware
device ... what the board guy wishes to do when the interrupt expires
is up to the board guy and that may include doing a debug dump
somewhere ... that is most definitely not a realm i want to tread into
it ;)
-mike
