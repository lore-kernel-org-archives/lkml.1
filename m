Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbYDDGRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbYDDGRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 02:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYDDGQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 02:16:51 -0400
Received: from ns.unixsol.org ([193.110.159.2]:44169 "EHLO ns.unixsol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbYDDGQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 02:16:50 -0400
Message-ID: <47F5C7D1.1080906@unixsol.org>
Date: Fri, 04 Apr 2008 09:16:49 +0300
From: Georgi Chorbadzhiyski <gf@unixsol.org>
Organization: Unix Solutions Ltd. (http://unixsol.org)
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc6: WARNING: at net/ipv4/tcp_input.c:2510
References: <47EBCB75.6030600@unixsol.org> <Pine.LNX.4.64.0804031315360.21524@wrl-59.cs.helsinki.fi>
In-Reply-To: <Pine.LNX.4.64.0804031315360.21524@wrl-59.cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around 04/03/08 13:17, Ilpo Järvinen scribbled:
> On Thu, 27 Mar 2008, Georgi Chorbadzhiyski wrote:
> 
>> A week ago I updated one of my servers to 2.6.25-rc6 and today looking
>> through logs I've found these:
>>
>> [380219.823434] ------------[ cut here ]------------
>> [380219.823450] WARNING: at net/ipv4/tcp_input.c:2510 tcp_ack+0xc7e/0x177d()
> 
> Is this reproducable for you? If yes, is it possible for you to run 

Not in the moment.

I'm not getting such errors in the log since my last report. Today I'll update
to latest -git and will restart the server.

The machine that gave me this error is a http and ftp server handling not
very busy distro mirror (if this can give you any clues).

> processing expensive verification of TCP state (validates TCP write queue 
> invariants multiple times per ACK by scanning through the write queue) on 
> such machine?

How to run such a thing, can you give me some pointers?

-- 
Georgi Chorbadzhiyski
http://georgi.unixsol.org/
