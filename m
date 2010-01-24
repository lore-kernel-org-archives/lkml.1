Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313Ab0AXJbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab0AXJbH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 04:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446Ab0AXJbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 04:31:05 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:45097 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab0AXJbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 04:31:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nmc1Eb0g+73uO0pE1XT1VPmN2/2JwRkYm5+rgTFJoziFglrcmsC20KnrJ5NaNbUq1Y
         WR+/tT2TXCbD0Rv1yTCBu402o0sHumlVS98KdulWce8aP47sTP9WqTtMTvqjgk0239vB
         YBsA4dg8mExDxtkD2Mor/ZgNc/g9Pvryg1qi0=
Date: Sun, 24 Jan 2010 01:30:55 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Guillaume Chazarain <guichaz@gmail.com>
Cc: ajax@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: evdev regression on macbook with 2.6.33-rc5
Message-ID: <20100124093055.GA17607@core.coreip.homeip.net>
References: <3d8471ca1001231053k512011dcnfab50052ce3667fa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d8471ca1001231053k512011dcnfab50052ce3667fa@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guillaume,

On Sat, Jan 23, 2010 at 07:53:58PM +0100, Guillaume Chazarain wrote:
> Hi,
> 
> Since 2.6.33-rc5, the keyboard on my MacBookPro 3,1 stopped working
> when using X.
> It works fine in console mode, but in X, pressing keys does not have
> any effect until I hit the touchpad or an USB mouse and then all the
> keystrokes are delivered.
> I'm using the nvidia proprietary drivers on Ubuntu 9.10 x86_64
> (config.gz and dmesg.gz attached).
> 
> A git bisection found this commit as the culprit and reverting it
> indeed fixes the problem:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=30a589fde0162aa4dac7c69803aeee8fbe8d1b82
> 
> commit 30a589fde0162aa4dac7c69803aeee8fbe8d1b82
> Author: Adam Jackson <ajax@redhat.com>
> Date:   Tue Jan 5 17:56:04 2010 -0800
> 
>     Input: evdev - be less aggressive about sending SIGIO notifies
> 
> Thanks.
> 


DOes the same behavior happens when you try using 'evtest' utility while
in console? Also, do you have external USB keyboard by any chance and if
you do does it exibit the same problem?

Thanks.

-- 
Dmitry
