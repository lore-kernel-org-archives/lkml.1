Return-Path: <linux-kernel-owner+w=401wt.eu-S1751929AbZGKLJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbZGKLJr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 07:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbZGKLJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 07:09:40 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:48397 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbZGKLJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 07:09:40 -0400
Date: Sat, 11 Jul 2009 07:07:23 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what means "module_param(channel_mask, channel_mask, 0644)"?
In-Reply-To: <alpine.LFD.2.00.0907110658370.4257@localhost>
Message-ID: <alpine.LFD.2.00.0907110704540.4491@localhost>
References: <alpine.LFD.2.00.0907110658370.4257@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jul 2009, Robert P. J. Day wrote:

>   researching my next newbie column about module parameters and i
> ran across the following:
>
> drivers/input/misc/ati_remote2.c:module_param(channel_mask, channel_mask, 0644);
> drivers/input/misc/ati_remote2.c:module_param(mode_mask, mode_mask, 0644);
>
> i have no idea what it means to have the second (type) field of
> module_param() simply repeat the name of the parameter.  is this
> some strange magic?  those two names don't *appear* to be typedef'ed
> anywhere i can see.

  i should have added that the reason i ran across this was that i was
curious if anyone was using User Defined Parameter Types as explained
here:

http://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:module_parameters

so i did a quick grep for any invocations of module_param() whose type
wasn't one of the standard int, boot, short, ... etc ... and those two
hits above showed up, which confused me.

  so ... *is* anyone taking advantage of user-defined module parameter
types?  not as i can tell, but maybe i just missed it.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
"Kernel Newbie Corner" column @ linux.com:          http://cli.gs/WG6WYX
========================================================================
