Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYJGHZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYJGHZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 03:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYJGHY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 03:24:58 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:50718 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbYJGHY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 03:24:57 -0400
Date: Tue, 7 Oct 2008 09:23:46 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: Remove sysfs_do_create_link().
Message-ID: <20081007092346.101e8958@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20081007041933.GA14843@kroah.com>
References: <20080917130805.6260ba9c@gondolin.boeblingen.de.ibm.com>
	<m1r67i61rh.fsf@frodo.ebiederm.org>
	<20080918090705.6985cced@gondolin.boeblingen.de.ibm.com>
	<m17i99wz7k.fsf@frodo.ebiederm.org>
	<20080918125056.03c404e8@gondolin.boeblingen.de.ibm.com>
	<m1y71pvg5d.fsf@frodo.ebiederm.org>
	<20080918142806.20568dda@gondolin.boeblingen.de.ibm.com>
	<20081007041933.GA14843@kroah.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2008 21:19:33 -0700,
Greg KH <greg@kroah.com> wrote:

> On Thu, Sep 18, 2008 at 02:28:06PM +0200, Cornelia Huck wrote:
> > Since sysfs_create_link_nowarn() is gone, sysfs_do_create_link()
> > is an unneeded indirection: Remove it.
> 
> Is this still needed, now that I've dropped Eric's patchset?

No, this was just a cleanup on top.
