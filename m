Return-Path: <linux-kernel-owner+w=401wt.eu-S1763369AbXJZPxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763369AbXJZPxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760540AbXJZPww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:52:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52882 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760191AbXJZPwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:52:51 -0400
Date: Fri, 26 Oct 2007 08:52:02 -0700
From: Greg KH <greg@kroah.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Amit Shah <amitshah@gmx.net>,
       alsa-devel@alsa-project.org
Subject: Re: sysfs: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one() - with
	ALSA
Message-ID: <20071026155202.GD23016@kroah.com>
References: <877aabc40710260014v220ab804o5de5dbc36b870bd1@mail.gmail.com> <20071026091722.GA21274@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026091722.GA21274@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 02:47:22PM +0530, Kamalesh Babulal wrote:
> I get similar warning, while loading the alsa driver

This is a different problem, not a rename issue like the network one
was.

> [  191.933548] Advanced Linux Sound Architecture Driver Version 1.0.15
> (Tue Oct 23 06:09:18 2007 UTC).
> [  191.996323] ALSA sound/core/seq/oss/seq_oss.c:232: can't register
> device seq
> [  192.046004] sysfs: duplicate filename 'audio' can not be created
> [  192.086048] WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()

This is an error in the alsa core, perhaps the alsa developers can help
figure out why they are registering the same file twice?

thanks,

greg k-h
