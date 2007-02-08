Return-Path: <linux-kernel-owner+w=401wt.eu-S1423228AbXBHQh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423228AbXBHQh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 11:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423224AbXBHQh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 11:37:58 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:1438 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423226AbXBHQh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 11:37:56 -0500
Date: Thu, 8 Feb 2007 10:35:15 -0600 (CST)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@localhost.localdomain
To: Jeff Garzik <jeff@garzik.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <45CB3B28.60102@garzik.org>
Message-ID: <Pine.LNX.4.64.0702081033490.18157@localhost.localdomain>
References: <45CB3B28.60102@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007, Jeff Garzik wrote:

> Just did a pull for the first time since 2.6.20, and a /megaton/ of new 
> warnings have appeared, on Fedora Core 6/x86-64 "make allyesconfig".
>
> All of the new warnings spew appear to be "pointers differ in signedness" 
> warning.  Granted, we should care about these, but even a "silent" build 
> (make -s) now spews far more output than any human could possibly care about, 
> and digging important nuggets out of all this noise is beginning to require 
> automated tools rather than just human eyes.

I think this is because of changes to Kbuild and the ongoing discussion 
related to it.  On PPC I see that we are losing options via $(call 
cc-option..)

- k
