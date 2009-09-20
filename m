Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbZITUWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbZITUWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 16:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZITUWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 16:22:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51097 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbZITUWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 16:22:17 -0400
Date: Sun, 20 Sep 2009 22:22:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Kara <jack@suse.cz>
Subject: Re: Poor desktop responsiveness with background I/O-operations
In-Reply-To: <4AB59CBB.8090907@datenparkplatz.de>
Message-ID: <alpine.LRH.2.00.0909202221010.25928@twin.jikos.cz>
References: <4AB59CBB.8090907@datenparkplatz.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Sep 2009, Ulrich Lukas wrote:

> Test case:
> - 64-bit dual-core PC, SATA harddrive, plenty of free RAM
> - vanilla Linux 2.6.31, Kubuntu 9.10 packages, all software 64-bit
> 
> 
> How to reproduce:
> - start KDE/GNOME-session
> - open a terminal window and do as a non-root user:
>   dd if=/dev/zero of=/home/john-doe/testfile
>   (or dd if=/home/john-doe/big-testfile of=/dev/null)
> 
> - a real use scenario would be a daily disk-backup or the
>   simple extraction of a tarball containing slightly bigger files
> 
> 
> Observation:
> - The system becomes _really_ slow as described above; unusable for
>   any multimedia tasks.

I guess that switching from CFQ to deadline I/O scheduler improves the 
situation, right?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

