Return-Path: <linux-kernel-owner+w=401wt.eu-S1752602AbYAMOcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbYAMOcS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 09:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbYAMOcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 09:32:08 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:37119 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbYAMOcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 09:32:07 -0500
Date: Sun, 13 Jan 2008 15:32:04 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: xerces8 <xerces8@butn.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: isofs maintainer and write support
In-Reply-To: <WorldClient-F200801131428.AA28580079@butn.net>
Message-ID: <Pine.LNX.4.64.0801131529370.30102@fbirervta.pbzchgretzou.qr>
References: <WorldClient-F200801131428.AA28580079@butn.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 13 2008 14:28, xerces8 wrote:
>
>I write here as the MAINTAINERS file has no entry about the isofs.


>
>The question is : Is there any plan/way/idea to have read/write support
>for isofs ?
>
>I know of user space tools that can perform any operation (like
>create/read/write/rename/delete file/directory) but that is nowhere
>as convenient as a real filesystem.

No. ISO-9660 is not meant to be randomly written, just like romfs,
cramfs and squashfs and .tar.gz/.tar.bz2 files. Userspace tools
recreate the whole ISO (or are very smart in reordering blocks). Use
UDF instead.
