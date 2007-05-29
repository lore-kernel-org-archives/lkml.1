Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbXE2RXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbXE2RXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 13:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbXE2RXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 13:23:35 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:51198 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbXE2RXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 13:23:34 -0400
Date: Tue, 29 May 2007 19:23:34 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Tejun Heo" <htejun@gmail.com>
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>, gregkh@suse.de,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 2.6.22-rc2-mm1] sysfs: reduce memory footprint of
 sysfs_dirent
Message-ID: <20070529192334.4725ea90@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070529181759.4d4a664f@gondolin.boeblingen.de.ibm.com>
References: <118036944617-git-send-email-htejun@gmail.com>
	<d120d5000705290904s706763bfj7beb837397f54d86@mail.gmail.com>
	<20070529181759.4d4a664f@gondolin.boeblingen.de.ibm.com>
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

On Tue, 29 May 2007 18:17:59 +0200,
Cornelia Huck <cornelia.huck@de.ibm.com> wrote:

> The patchset seems to work fine so far on the (small z/VM guest) system
> I tested it a bit on; I'll try a huge (LPAR) system next.

Seems fine as well. I got 12MB more of free memory, with ~3000
subchannels (a ccw device behind each) and a few system devices.
