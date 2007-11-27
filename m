Return-Path: <linux-kernel-owner+w=401wt.eu-S1758328AbXK0Fep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328AbXK0Fep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 00:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbXK0FeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 00:34:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41666 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbXK0FeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 00:34:24 -0500
Date: Mon, 26 Nov 2007 21:29:55 -0800
From: Greg KH <greg@kroah.com>
To: Konrad Rzeszutek <konrad@darnok.org>
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com, hpa@zytor.com,
       lenb@kernel.org, mike.anderson@us.ibm.com, dwm@austin.ibm.com
Subject: Re: [PATCH] Add iSCSI IBFT Support (v0.3)
Message-ID: <20071127052955.GB777@kroah.com>
References: <20071126225642.GA7973@andromeda.dapyr.net> <20071127033138.GB30770@kroah.com> <200711262323.35416.konrad@darnok.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711262323.35416.konrad@darnok.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 11:23:31PM -0500, Konrad Rzeszutek wrote:
> On Monday 26 November 2007 22:31:38 Greg KH wrote:
> > > +#if defined(CONFIG_ISCSI_IBFT) || defined(CONFIG_ISCSI_IBFT_MODULE)
> ..snip..
> > > +static ssize_t find_ibft(void)
> > > +{
> ..snip..
> > > +}
> >
> > What is a function (not even an inline one) doing in a .h file?
> 
> I was not sure where to put it. This function (find_ibft) is used by the 
> setup_[32|64].c and the iscsi_ibft.c code. Randy suggested I put in .c file, 
> but I am not sure exactly where? Should I make a new file in called 
> libs/iscsi_ibft_helper.c ?

Put it in your .c file and make it a global function to be called by
someone else if they need it.

thanks,

greg k-h
