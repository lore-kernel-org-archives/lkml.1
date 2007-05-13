Return-Path: <linux-kernel-owner+w=401wt.eu-S1758346AbXEMGBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346AbXEMGBS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 02:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757093AbXEMGBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 02:01:05 -0400
Received: from relay4.usu.ru ([194.226.235.39]:39044 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757067AbXEMGBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 02:01:03 -0400
Message-ID: <4646A9F8.5080900@ums.usu.ru>
Date: Sun, 13 May 2007 12:02:32 +0600
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: "=?ISO-8859-2?Q?Wojciech_Zabo=B3otny?=" <W.Zabolotny@elka.pw.edu.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sis900 module causes kernel panic in 2.6.21.1 (fatal exception
 in   interrupt)
References: <4645FDA7.4080809@elka.pw.edu.pl>
In-Reply-To: <4645FDA7.4080809@elka.pw.edu.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wojciech Zabo³otny wrote:
> Hi All,
> 
> The kernel 2.6.21.1 hangs with kernel panic on my laptop, whenever I try
> to use the network more intensively (a few pings do not cause the
> problem, but an attempt to ssh somewhere does...)

Known bug, here is a fix:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=dc5a144991ba803bc8afded105c9db1dea0e57ab

-- 
Alexander E. Patrakov
