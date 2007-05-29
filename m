Return-Path: <linux-kernel-owner+w=401wt.eu-S1761971AbXE2G3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761971AbXE2G3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 02:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbXE2G24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 02:28:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:26357 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbXE2G2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 02:28:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AcK3LDF8SBRV4zlO4vNIKOZ8T3ApplOXWEGRdjHo6NyfgAwGfNg4J7C4FDbGCqZWfu77wWKNE1kV2slY1MjSdOlCC6xLPAPW5a24Ulle6rl0qeybclmseTXAcVsFdpwUoMKGDDdx/G5oKBwu741Y5KvmgFWP3Gt5UzIu3I3Zn44=
Message-ID: <a781481a0705282328u54a14143jc60194fcf7b5aa23@mail.gmail.com>
Date: Tue, 29 May 2007 11:58:54 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Bill Davidsen" <davidsen@tmr.com>
Subject: Re: What causes iowait other than waiting for i/o?
Cc: "Linux Kernel mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <465B4B75.2040602@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <465B4B75.2040602@tmr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bill,

On 5/29/07, Bill Davidsen <davidsen@tmr.com> wrote:
> I recently noted that my system was spending a lot of time in i/o wait
> when doing some tasks which I thought didn't involve i/o, as noted by
> the lack of disk light activity most of the time. I thought of network,
> certainly the NIC had no activity for this job. So I set up a little
> loop to capture all disk i/o and network activity (including loopback).
> That was no obvious help, and the program doesn't use pipes.
>
> At this point I'm really curious, does someone have a good clue?
>
> Note: I don't think this is a bug or performance issue, unless the
> kernel is doing something and charging time to iowait instead of system
> I don't see anything to fix, but I would like to understand.

What tool / kernel instrumentation / mechanism are you using to
determine that some task(s) are indeed blocked waiting for i/o? Perhaps
some userspace process accounting tools could be "broken" in the sense
that they generalize all uninterruptible sleep as waiting for i/o ...

Satyam
