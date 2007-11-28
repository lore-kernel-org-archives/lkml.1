Return-Path: <linux-kernel-owner+w=401wt.eu-S1758786AbXK1UfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbXK1UfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 15:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbXK1UfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 15:35:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42947 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbXK1UfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 15:35:07 -0500
Date: Wed, 28 Nov 2007 12:33:21 -0800
From: Greg KH <greg@kroah.com>
To: darnok@68k.org
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com, hpa@zytor.com,
       lenb@kernel.org, mike.anderson@us.ibm.com, dwm@austin.ibm.com
Subject: Re: [PATCH] Add iSCSI IBFT Support (v0.3)
Message-ID: <20071128203321.GA24547@kroah.com>
References: <20071126225642.GA7973@andromeda.dapyr.net> <20071127033138.GB30770@kroah.com> <200711262323.35416.konrad@darnok.org> <20071127052955.GB777@kroah.com> <20071127180950.GA6736@andromeda.dapyr.net> <20071127190919.GA10686@kroah.com> <20071128192140.GB6736@andromeda.dapyr.net> <20071128194543.GA2469@kroah.com> <20071128202432.GC6736@andromeda.dapyr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128202432.GC6736@andromeda.dapyr.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 04:24:32PM -0400, darnok@68k.org wrote:
> > But, why not just put it in a separate file, that is built in if the
> > user wants iscsi support?  That way the setup code can call it properly
> > if needed.
> 
> In what directory should I put that file? It can't be in the arch/*
> directories b/c the iscsi_ibft.c wouldn't build on all platforms.
> Should I put it in drivers/firmware ?

Put it in the same directory your other iscsi files are.  Or wherever
you feel it is best suited.

thanks,

greg k-h
