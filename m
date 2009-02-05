Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbZBEK7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbZBEK7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 05:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbZBEK72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 05:59:28 -0500
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:51934 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878AbZBEK71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 05:59:27 -0500
X-DKIM: Sendmail DKIM Filter v2.6.0 mail-in-06.arcor-online.net 18A5639AAE7
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: shrinking root partition and using free space to create a block  	device
To: Prateek Donni <prateek.donni@gmail.com>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Thu, 05 Feb 2009 11:59:16 +0100
References: <c1wtJ-5GM-23@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LV1wz-0001NS-3Z@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prateek Donni <prateek.donni@gmail.com> wrote:

> We are intending to protect a set of user specified files using LVM
> mirroring where the protected space on which the user files are stored
> is mirrored on an LV on a different disk. Our problem is that for a
> user with a custom layout has installed linux with 2 partitons for
> swap and / and there is no other space available on the primary disk
> where we can store the files to be protected tht is mirrored across
> other disk, so we intend to allocate some space on the primary disk
> that can be used as a LV that is mirrored across an LV on different
> disk.
> What can be done in this situation?

Use a network share or a network block device.

