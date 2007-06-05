Return-Path: <linux-kernel-owner+w=401wt.eu-S932685AbXFEVB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685AbXFEVB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933048AbXFEVA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:00:56 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:49398 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933037AbXFEVAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:00:54 -0400
Date: Tue, 5 Jun 2007 17:00:51 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       Alan Cox <alan@redhat.com>, drepper@redhat.com, roland@redhat.com,
       arjan@infradead.org, mingo@elte.hu, viro@zeniv.linux.org.uk,
       chrisw@redhat.com, sds@tycho.nsa.gov, sgrubb@redhat.com
Subject: Re: [PATCH] Protection for exploiting null dereference using mmap
In-Reply-To: <1181075666.3978.31.camel@localhost.localdomain>
Message-ID: <Line.LNX.4.64.0706051658170.23379@d.namei>
References: <1180561713.3633.27.camel@dhcp231-215.rdu.redhat.com> 
 <20070603205653.GE25869@devserv.devel.redhat.com> 
 <1180964306.14220.34.camel@moss-spartans.epoch.ncsc.mil>
 <1181075666.3978.31.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, Eric Paris wrote:

> +extern int mmap_protect_memory;

This should be an unsigned long.

I wonder if the default should be for this value to be zero (i.e. preserve 
existing behavior).  It could break binaries, albeit potentially insecure 
ones.


- James
-- 
James Morris
<jmorris@namei.org>
