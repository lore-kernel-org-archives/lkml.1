Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbYCWEsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbYCWEsE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 00:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYCWErz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 00:47:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:53148 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbYCWEry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 00:47:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kSagkMzkuz8UfybE1f/8o2DWjTjdSpcGdqIAGR5sd1NSvWYJWN8wkfXH0BJVMG2mAkIBfJjkJuvYbppFYRx7T06Wln4A+ih5SAlIf7rZntAG3+T457/W0gt3sT5GYFTkBX/tIp1bDgclB/xB96Tf2pzsGqN3TW/4sLlWT3uhe4g=
Message-ID: <2c0942db0803222147y27954bd6hf4cb0cc98ceda2da@mail.gmail.com>
Date: Sat, 22 Mar 2008 21:47:52 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: Kai <epimetreus@fastmail.fm>
Subject: Re: Serious performance regression in Wine applications and Linux 2.6.24.*
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1206240595.9045.1243810639@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206240595.9045.1243810639@webmail.messagingengine.com>
X-Google-Sender-Auth: 50497d738f5bd5ac
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2008 at 7:49 PM, Kai <epimetreus@fastmail.fm> wrote:
> Performance degrades by about 60% when I run Wine under any of the
>  2.6.24.* kernels. Attached are the output of lspci -vv and the two
>  config files of each kernel.
>
>  I upgraded to 2.6.24, back to 2.6.23.(not sure), then tried 2.6.24.1 and
>  2.6.24.3 and the issue is present in both; it's severe enough that Wine
>  apps are virtually unusable for me with this version of the kernel; I'm
>  having to use 2.6.23 until this somehow is resolved.
>
>  I'd like some help figuring out why this performance regression exists,
>  and what can be done to mitigate it.

As wine has a 'wineserver' running in a separate process, it may be
related to scheduler changes.

Regardless, if you have the time, please retest using he latest git
head (or nightly snapshot), and see if the performance regression is
still there, and report back. (There have been a lot of changes
between 2.6.24 and current git head that impact the scheduler.)

Please ensure that the fair group scheduler is disabled in your tests
(just as you have in your 2.6.24 config you attached).
