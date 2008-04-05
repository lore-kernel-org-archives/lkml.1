Return-Path: <linux-kernel-owner+w=401wt.eu-S1752407AbYDELJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbYDELJi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 07:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYDELJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 07:09:27 -0400
Received: from ns.unixsol.org ([193.110.159.2]:44252 "EHLO ns.unixsol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbYDELJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 07:09:26 -0400
Message-ID: <47F75DE5.4060407@unixsol.org>
Date: Sat, 05 Apr 2008 14:09:25 +0300
From: Georgi Chorbadzhiyski <gf@unixsol.org>
Organization: Unix Solutions Ltd. (http://unixsol.org)
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc6: WARNING: at net/ipv4/tcp_input.c:2510
References: <47EBCB75.6030600@unixsol.org> <Pine.LNX.4.64.0804031315360.21524@wrl-59.cs.helsinki.fi> <47F5C7D1.1080906@unixsol.org> <Pine.LNX.4.64.0804042209530.415@wrl-59.cs.helsinki.fi>
In-Reply-To: <Pine.LNX.4.64.0804042209530.415@wrl-59.cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around 04/04/08 22:15, Ilpo Järvinen scribbled:
>> The machine that gave me this error is a http and ftp server handling not
>> very busy distro mirror (if this can give you any clues).
>>
>>> processing expensive verification of TCP state (validates TCP write queue 
>>> invariants multiple times per ACK by scanning through the write queue) on 
>>> such machine?
>> How to run such a thing, can you give me some pointers?
> 
> I sent the patch recently to netdev/lkml:
> 
>   http://marc.info/?l=linux-netdev&m=120733529216457&w=2
> 
> But it's very expensive in processing wise so it might not be wise to put 
> it in if performance is important for you.

Ok, I patched the kernel and will let it run for a while. Performance is
an issue but I think it's better to pinpoint the bug.

-- 
Georgi Chorbadzhiyski
http://georgi.unixsol.org/
