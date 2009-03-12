Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbZCLPQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbZCLPQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 11:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673AbZCLPQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 11:16:25 -0400
Received: from mail.netone.net.tr ([193.192.98.182]:31355 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539AbZCLPQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 11:16:24 -0400
Message-ID: <49B92744.5040106@turknet.net.tr>
Date: Thu, 12 Mar 2009 17:16:20 +0200
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: ext4 problem on Linux-2.6.29-rc7-git4
References: <49B7D979.7010406@turknet.net.tr> <20090312150235.GD11748@mit.edu>
In-Reply-To: <20090312150235.GD11748@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Mar 2009 15:16:21.0506 (UTC) FILETIME=[8019C620:01C9A325]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> It's a warning, not an error; but I didn't expect it to be quite so
> voluminous in terms of log messages.  We have a proper fix for it
> queued up for 2.6.30, but it was considered too invasive.  So the fix
> was to print a warning which we ratelimited, but it looks like it's
> even with the printk_ratelimit the warnings are too annoying to let
> live.  I'll probably fix it to only printk the message once.
>
>        	    	     	       	    	       - Ted
>   
Good to hear that it was just a warning and not a bug/problem ;-)
I think, I can live with these warnings in my dmesg till 2.6.30! :-P
