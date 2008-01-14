Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbYANW0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbYANW0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756036AbYANWRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:17:15 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:46153 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897AbYANWRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:17:01 -0500
Date: Mon, 14 Jan 2008 23:17:00 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Olaf Titz <olaf@bigred.inka.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Possibly silly Q?
In-Reply-To: <E1JEWrk-0004FY-PT@bigred.inka.de>
Message-ID: <Pine.LNX.4.64.0801142316240.2315@fbirervta.pbzchgretzou.qr>
References: <200801141434.00934.gene.heskett@gmail.com> <E1JEWrk-0004FY-PT@bigred.inka.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 14 2008 22:29, Olaf Titz wrote:
>> 200Mb had been filled when it had been umounted from /mnt/bootf8
>> repartitioned, mke2fs'd, a journal added and a new label written and then
>> mounted to /amandatapes.
>>
>> Something it seems to me, should have forced the re-init, but didn't.  So is
>
>Something I stumbled across just a few days ago: fdisk does cause the
>kernel to re-read the new partitions, but nothing causes udev to
>create any required new device nodes...

- kobject_del - will cause udev to delete /dev/sd??
- kernel rescans partitions
- kobject_add - will cause udev to add /dev/sd??

simple :)
