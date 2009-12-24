Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbZLXMop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbZLXMop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 07:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbZLXMoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 07:44:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:42366 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459AbZLXMon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 07:44:43 -0500
Message-ID: <4B336303.2090403@kernel.org>
Date: Thu, 24 Dec 2009 21:48:03 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>
CC: linux-kernel@vger.kernel.org, stern@rowland.harvard.edu, x86@kernel.org
Subject: Re: 2.6.32 regression: unable to handle kernel paging request
References: <4B269765.1070703@klingt.org> <4B2A2A7D.1050506@klingt.org> <4B2A93F2.3070407@klingt.org> <4B2AFBB1.3040609@kernel.org> <4B2B4838.6080509@klingt.org> <4B2F20E0.30804@kernel.org> <4B2F40C0.5020407@klingt.org> <4B33592B.6000107@kernel.org> <4B335964.6040202@klingt.org> <4B335DE6.9030102@kernel.org>
In-Reply-To: <4B335DE6.9030102@kernel.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On 12/24/2009 09:26 PM, Tejun Heo wrote:
>> GNU ld (GNU Binutils for Ubuntu) 2.20
> 
> Sections aren't supposed to have addresses assigned in relocatable
> output and it of course breaks things.  I'll try newer version of
> binutils but at this point it looks like a linker bug.  Can you please
> report it to ubuntu too?

I just tried 2.20 on openSUSE.

 $ ld --version
 GNU ld (GNU Binutils; devel:gcc / openSUSE_11.2) 2.20.0.20091104-13.2
 Copyright 2009 Free Software Foundation, Inc.
 This program is free software; you may redistribute it under the terms of
 the GNU General Public License version 3 or (at your option) a later version.
 This program has absolutely no warranty.

and it doesn't show such behavior.  Can you please report this to
ubuntu and let me know the bug#?

Thanks.

-- 
tejun
