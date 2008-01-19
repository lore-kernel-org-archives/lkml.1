Return-Path: <linux-kernel-owner+w=401wt.eu-S1751683AbYASTmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbYASTmJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 14:42:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYASTlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 14:41:55 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:59208 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbYASTly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 14:41:54 -0500
Date: Sat, 19 Jan 2008 20:41:53 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
cc: Lars Callenbach <lars.callenbach@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: linux device ordering at boot time
In-Reply-To: <6101e8c40801191114v4492d8fer4da13477ef2d5626@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0801192040540.4780@fbirervta.pbzchgretzou.qr>
References: <20080119185520.208350@gmx.net> <6101e8c40801191114v4492d8fer4da13477ef2d5626@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 19 2008 20:14, Oliver Pinter (Pintér Olivér) wrote:
>
>I don't know, what the proble, but the fstab workaround  functioniert:
>form:
>/dev/sda3       /               xfs     defaults        0       1
>to:
>UUID=7c167a53-30ff-4d47-a206-ce8caf2397ba       /               xfs
> defaults        0       1
>
>in this fix switched form device name to UUID based fstab.
>
>the uuid-s queried with /lib/udev/vol_id program

Any distro that uses udev can use /dev/disk/by-.../...
without having to resort to per-program specific implementations
(or lack thereof) of UUID= or LABEL=.

