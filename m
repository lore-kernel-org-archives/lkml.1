Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbXEXGv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbXEXGv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 02:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbXEXGvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 02:51:19 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:63634 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbXEXGvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 02:51:18 -0400
Date: Thu, 24 May 2007 08:51:16 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC PATCH] /sys/block -> /sys/class/block  (Fedora 3 & 4
 testers wanted)
Message-ID: <20070524085116.6d384556@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070523180842.GA11999@kroah.com>
References: <20070521235353.GA6242@kroah.com>
	<20070522102501.72f40828@gondolin.boeblingen.de.ibm.com>
	<20070522182812.79b53880@gondolin.boeblingen.de.ibm.com>
	<20070523003255.GA3675@kroah.com>
	<20070523073959.0f5cb104@gondolin.boeblingen.de.ibm.com>
	<20070523180842.GA11999@kroah.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 11:08:42 -0700,
Greg KH <greg@kroah.com> wrote:

> Ok, yeah, that is wierd.
> 
> Kay found the problem (he's traveling right now) and here's his updated
> version of the patch which should work for everyone involved.
> 
> Please let me know if this causes any problems or not.

Ah, this seems to work fine now (both with and without
CONFIG_SYSFS_DEPRECATED; when it is set, even lsdasd seems happy).
Thanks!
