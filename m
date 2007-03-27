Return-Path: <linux-kernel-owner+w=401wt.eu-S932159AbXC0XWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbXC0XWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 19:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932561AbXC0XWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 19:22:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39793 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbXC0XWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 19:22:15 -0400
Date: Tue, 27 Mar 2007 15:51:39 -0700
From: Greg KH <greg@kroah.com>
To: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
Cc: usagi-core@linux-ipv6.org, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: (usagi-core 32640) Re: [linux-usb-devel] [PATCH 0/2] [SERIAL]
	[USB] fixed to skip NULL entry in struct serial usb_serial_port.
Message-ID: <20070327225139.GE4478@kroah.com>
References: <20070324212253.GA26215@kroah.com> <20070325.144740.432839277.takamiya@linux-ipv6.org> <20070325155521.GA11663@kroah.com> <20070326.093815.465778826.takamiya@po.ntts.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326.093815.465778826.takamiya@po.ntts.co.jp>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 09:38:15AM +0900, Noriaki TAKAMIYA wrote:
> Hi,
> 
> >> Sun, 25 Mar 2007 08:55:21 -0700
> >> [Subject: (usagi-core 32640) Re: [linux-usb-devel] [PATCH 0/2] [SERIAL] [USB] fixed to skip NULL entry in struct serial usb_serial_port.]
> >> Greg KH <greg@kroah.com> wrote...
> 
> > >   Yes, this problem was already fixed.
> > 
> > Great, thanks for testing.  So I guess both of these patches are no
> > longer necessary, right?
> 
>   I think so. But I wonder if usb_get_serial_port_data() should check
>   the argument for the other drivers.

I don't think it is really necessary, do you?

thanks,

greg k-h
