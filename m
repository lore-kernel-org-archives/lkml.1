Return-Path: <linux-kernel-owner+w=401wt.eu-S935628AbYBCAyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935628AbYBCAyt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 19:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765572AbYBCAym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 19:54:42 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:48548 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbYBCAym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 19:54:42 -0500
Date: Sun, 3 Feb 2008 01:54:41 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: devzero@web.de
cc: Laurent.Vivier@bull.net, linux-kernel@vger.kernel.org, pavel@ucw.cz
Subject: Re: [PATCH] Allow NBD to be used locally
In-Reply-To: <141350930@web.de>
Message-ID: <Pine.LNX.4.64.0802021834380.18790@fbirervta.pbzchgretzou.qr>
References: <141350930@web.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 2 2008 18:31, devzero@web.de wrote:
>
>> How will that work? Fuse makes up a filesystem - not helpful
>> if you have a raw disk without a known fs to mount.
>
>take zfs-fuse or ntfs-3g for example. 
>you have a blockdevice or backing-file containing data structures and fuse makes those show up as a filesystem.
>i think vmware-mount is not different here.

vmware-mount IS different, it provides the _block_ device,
which is then mounted through the usual mount(2) mechanism
(if there is a filesystem driver for it).
