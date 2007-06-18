Return-Path: <linux-kernel-owner+w=401wt.eu-S1762184AbXFRLdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762184AbXFRLdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 07:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761062AbXFRLdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 07:33:10 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:56942 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760823AbXFRLdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 07:33:08 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 18 Jun 2007 07:30:43 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Magnus Naeslund <mag@kite.se>
cc: linux-kernel@vger.kernel.org
Subject: Re: ARC-1260: No space left on device, when there is (or should be)
 free space left
In-Reply-To: <4676679E.5040901@kite.se>
Message-ID: <Pine.LNX.4.64.0706180730320.14972@localhost.localdomain>
References: <4676679E.5040901@kite.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Magnus Naeslund wrote:

> It seems I have a problem accessing the whole device, it filled up too quickly.
> I thought I was avoiding the 2tb limit when not using any partition tables, shame on me :)
>
> # df -B 1 /dev/sdb
> Filesystem           1B-blocks      Used Available Use% Mounted on
> /dev/sdb             5999417057280 1908287229952 4091129827328  32% /storage/disk1
>
> (Ok here I have 68% free space on our 5.5TB device)

$ df -i

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
