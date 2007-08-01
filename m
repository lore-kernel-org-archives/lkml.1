Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbXHAVlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbXHAVlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 17:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbXHAVlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 17:41:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58070 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbXHAVlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 17:41:24 -0400
Date: Thu, 2 Aug 2007 03:23:46 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: =?UTF-8?Q?Rafa=C5=82_Bilski?= <rafalbilski@interia.pl>
cc: trivial@kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtdsuper: licensce = GPL
In-Reply-To: <46B0D1F7.9090805@interia.pl>
Message-ID: <alpine.LFD.0.999.0708020318070.8258@enigma.security.iitk.ac.in>
References: <46B0D1F7.9090805@interia.pl>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-220731455-1186005231=:8258"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-220731455-1186005231=:8258
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Wed, 1 Aug 2007, Rafał Bilski wrote:

> block2mtd: version $Revision: 1.30 $
> block2mtd: mtd0: [d: /dev/sdc2] erase_size = 64KiB [65536]
> mtdsuper: module license 'unspecified' taints kernel.
> mtdsuper: Unknown symbol get_mtd_device
> mtdsuper: Unknown symbol put_mtd_device
> jffs2: Unknown symbol get_sb_mtd
> jffs2: Unknown symbol kill_mtd_super

That's weird. I'm wondering how did you manage to build mtdsuper as a
separate module in the first place? It always gets linked with mtdcore
(which has all the necessary module decoration stuff) into the "mtd"
module itself, at least that;s what the Makefile says ...
--464262402-220731455-1186005231=:8258--
