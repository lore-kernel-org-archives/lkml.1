Return-Path: <linux-kernel-owner+w=401wt.eu-S1758929AbZKEX2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929AbZKEX2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 18:28:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbZKEX2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 18:28:10 -0500
Received: from kroah.org ([198.145.64.141]:34124 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbZKEX2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 18:28:09 -0500
Date: Thu, 5 Nov 2009 15:12:41 -0800
From: Greg KH <greg@kroah.com>
To: Massimo Cetra <mcetra@navynet.it>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, davem@davemloft.net, mpatocka@redhat.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [00/46] 2.6.31.5-stable review
Message-ID: <20091105231241.GC20799@kroah.com>
References: <20091016171422.GA13339@kroah.com>
 <4AD8B41F.2070702@navynet.it>
 <20091016180343.GA16808@suse.de>
 <4AD95424.70406@navynet.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD95424.70406@navynet.it>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 17, 2009 at 07:20:36AM +0200, Massimo Cetra wrote:
> Greg KH wrote:
> > On Fri, Oct 16, 2009 at 07:57:51PM +0200, Massimo Cetra wrote:
> >   
> >> Greg KH ha scritto:
> >>     
> >>> This is the start of the stable review cycle for the 2.6.31.5 release.
> >>> There are 46 patches in this series, all will be posted as a response to
> >>> this one.  If anyone has any issues with these being applied, please let
> >>> us know.  If anyone is a maintainer of the proper subsystem, and wants
> >>> to add a Signed-off-by: line to the patch, please respond with it.
> >>>
> >>>   
> >>>       
> >> Please consider adding this:
> >> http://lkml.org/lkml/2009/10/13/154
> >>
> >> and this:
> >> http://lkml.org/lkml/2009/10/14/430
> >>
> >> which definitely makes 2.6.31 unusable for virtualization with KVM and with 
> >> some block devices not supporting barriers.
> >>     
> >
> > Do you have git commit ids for these fixes?
> >
> >   
> No, sorry.
> 
> But maybe David Miller may help about this:
>   http://lkml.org/lkml/2009/10/13/154
> 
> and the other should be this one:
> 
>   commit 52b1fd5a27c625c78373e024bf570af3c9d44a79
>   Author: Mikulas Patocka <mpatocka@redhat.com>
>     dm: send empty barriers to targets in dm_flush

That commit is already in the 2.6.31 tree (it went into 2.6.31-rc1).

So there's not much I can do here :)

thanks,

greg k-h
