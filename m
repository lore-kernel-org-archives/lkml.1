Return-Path: <linux-kernel-owner+w=401wt.eu-S1754407AbYANTnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbYANTnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbYANTnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:43:47 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:35269 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbYANTnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:43:47 -0500
Date: Mon, 14 Jan 2008 20:43:45 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Gene Heskett <gene.heskett@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Possibly silly Q?
In-Reply-To: <200801141434.00934.gene.heskett@gmail.com>
Message-ID: <Pine.LNX.4.64.0801142043170.24893@fbirervta.pbzchgretzou.qr>
References: <200801141434.00934.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 14 2008 14:34, Gene Heskett wrote:
>
>Do we have a utility that can force the kernel to re-read, and re-initialize 
>itself to a given drives partition tables without having to reboot if one is 
>working with a drive that is not part of the required kernel directory tree?

fdisk issues an ioctl to reread the drive after you issued 'w'(rite).
Works.

