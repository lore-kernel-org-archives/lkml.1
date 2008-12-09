Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbYLITcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbYLITcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 14:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbYLITcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 14:32:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45226 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515AbYLITcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 14:32:31 -0500
Date: Tue, 9 Dec 2008 14:30:39 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Jan Rekorajski <baggins@sith.mimuw.edu.pl>, linux-kernel@vger.kernel.org,
       Holger Hoffstaette <holger@wizards.de>, netdev@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       stable@kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: Re: Nasty regression from .27.7 to .27.8: idle samba goes crazy
Message-ID: <20081209143039.036c9f91@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <493EC412.3090805@colorfullife.com>
References: <pan.2008.12.08.06.18.57.357875@wizards.de>
	<200812080834.22924.rjw@sisk.pl>
	<pan.2008.12.08.08.07.29.439625@wizards.de>
	<493D4F5C.7020606@s5r6.in-berlin.de>
	<493D7349.10200@s5r6.in-berlin.de>
	<20081208222246.GA29232@sith.mimuw.edu.pl>
	<20081209123703.043067eb@dhcp-100-2-144.bos.redhat.com>
	<493EC412.3090805@colorfullife.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Dec 2008 20:16:34 +0100
Manfred Spraul <manfred@colorfullife.com> wrote:

> Chuck Ebbert wrote:
> > Try reverting the idr patch that went into 2.6.27.8. It broke DRM in the
> > Fedora kernel at least.
> >
> >   
> What happens?
> Does it oops, does one of the BUG() statements trigger?
> 

It fails in strange ways, e.g. trying to open a DRM device causes it to
disappear. (And DRM is a heavy user of idr.)
