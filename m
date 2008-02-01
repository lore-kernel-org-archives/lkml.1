Return-Path: <linux-kernel-owner+w=401wt.eu-S935829AbYBAFDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935829AbYBAFDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 00:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935197AbYBAE5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:57:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42156 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935432AbYBAE5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:57:37 -0500
Message-ID: <47A2A54B.90703@zytor.com>
Date: Thu, 31 Jan 2008 20:51:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>, jikos@suse.cz
Subject: Re: how to tell i386 from x86-64 kernel
References: <20080201004212.GA2818@elf.ucw.cz>
In-Reply-To: <20080201004212.GA2818@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
> Quiz: on a booted system, how do you tell 32bit from 64bit kernel?
> 
> A1: zcat /proc/config.gz | grep CONFIG_64
> 
> ...but config.gz is optional
> 
> A2: cat /proc/meminfo  | grep High
> 
> ...but i386 kernel could have highmem disabled
> 
> What is _your_ answer? ;-)>
> 									Pavel

uname -m

	-hpa
