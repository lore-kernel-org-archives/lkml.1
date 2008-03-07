Return-Path: <linux-kernel-owner+w=401wt.eu-S932385AbYCGTw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbYCGTw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 14:52:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760347AbYCGTwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 14:52:17 -0500
Received: from hpsmtp-eml20.KPNXCHANGE.COM ([213.75.38.85]:14826 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760260AbYCGTwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 14:52:16 -0500
To: Gerold Jury <gml@inode.at>
Subject: Re: extra bytes written to SATA DVD drive on kernel 2.6.23 till 2.6.24.2
Cc: efault@gmx.de, htejun@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       vsu@altlinux.ru
In-reply-To: <200803072009.22551.gml@inode.at>
References: <200802252005.22663.gml@inode.at> <200803011329.11315.gml@inode.at> <47D0FF67.8050503@gmail.com> <47D0FF67.8050503@gmail.com> <200803072009.22551.gml@inode.at>
Message-Id: <E1JXic1-0000Yo-K8@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Fri, 07 Mar 2008 20:52:13 +0100
X-OriginalArrivalTime: 07 Mar 2008 19:52:13.0905 (UTC) FILETIME=[BD41EC10:01C8808C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerold Jury wrote:
> 0001ffe0  e0 ff e1 ff e2 ff e3 ff  e4 ff e5 ff e6 ff e7 ff  |................|
> 0001fff0  e8 ff e9 ff ea ff eb ff  ec ff ed ff ee ff ef ff  |................|
> 00020000  2a 00 00 00 00 40 00 00  40 00 00 00 00 40 00 00  |*....@..@....@..|

Looks broken here too.

> 00020010  08 ff 09 ff 0a ff 0b ff  08 ff 09 ff 0a ff 0b ff  |................|
> 00020020  00 00 01 00 02 00 03 00  04 00 05 00 06 00 07 00  |................|

It also seems like part gets repeated after the break in both cases.

Cheers,
FJP
