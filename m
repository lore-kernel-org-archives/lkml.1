Return-Path: <linux-kernel-owner+w=401wt.eu-S1762408AbXEPJQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762408AbXEPJQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 05:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760296AbXEPJQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 05:16:14 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:56323 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756058AbXEPJQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 05:16:13 -0400
Date: Wed, 16 May 2007 11:15:31 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Al Viro <viro@ftp.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Make prepare_namespace() wait for devices (v2)
Message-ID: <20070516111531.03164a36@dhcp-252-105.norway.atmel.com>
In-Reply-To: <46487DAE.5000206@drzeus.cx>
References: <464853D9.70904@drzeus.cx>
	<20070514123436.GB4095@ftp.linux.org.uk>
	<46486A7F.8050705@drzeus.cx>
	<20070514160403.6414f149@dhcp-252-105.norway.atmel.com>
	<46487DAE.5000206@drzeus.cx>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 17:18:06 +0200
Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> New suggestion.

Works wonderfully here:

Waiting for root device /dev/mmcblk0p1...
<inserts card>
mmcblk0: mmc0:a95c SD128 123008KiB
 mmcblk0: p1
VFS: Mounted root (ext2 filesystem).

Of course, it also fixes the case where the card _is_ inserted at
bootup :-)

Haavard
