Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbYANV7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbYANV7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852AbYANV7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:59:20 -0500
Received: from quechua.inka.de ([193.197.184.2]:34552 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701AbYANV7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:59:19 -0500
X-Greylist: delayed 1804 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jan 2008 16:59:18 EST
To: linux-kernel@vger.kernel.org
Subject: Re: Possibly silly Q?
References: <200801141434.00934.gene.heskett@gmail.com>
Organization: private Linux site, southern Germany
From: Olaf Titz <olaf@bigred.inka.de>
Date: Mon, 14 Jan 2008 22:29:08 +0100
Message-ID: <E1JEWrk-0004FY-PT@bigred.inka.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 200Mb had been filled when it had been umounted from /mnt/bootf8
> repartitioned, mke2fs'd, a journal added and a new label written and then
> mounted to /amandatapes.
>
> Something it seems to me, should have forced the re-init, but didn't.  So is

Something I stumbled across just a few days ago: fdisk does cause the
kernel to re-read the new partitions, but nothing causes udev to
create any required new device nodes...

Olaf
