Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbXJ3TpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbXJ3TpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbXJ3TpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:45:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:57958 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbXJ3TpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:45:06 -0400
Subject: Re: [PATCH] sysfs: add filter function to groups
From: Kay Sievers <kay.sievers@vrfy.org>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Greg KH <greg@kroah.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1193768743.3321.91.camel@localhost.localdomain>
References: <1193671019.3383.13.camel@localhost.localdomain>
	 <1193676852.2655.21.camel@lov.site>
	 <1193677071.3383.56.camel@localhost.localdomain>
	 <47261F50.3050901@s5r6.in-berlin.de>
	 <1193768743.3321.91.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 30 Oct 2007 20:47:13 +0100
Message-Id: <1193773633.12106.1.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18vLm03p0Wwb3xjhJe2JczsjP/h/AhhPfe8hF0
 NFKL7w1mWG/kaV74lFtK1+8xN3P4FndHWPc2j1sH+S6mNhhhdk
 P2BwvY6DecZex2ecJOQgmeAVFfsOGbM
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-30 at 13:25 -0500, James Bottomley wrote:
> On Mon, 2007-10-29 at 18:58 +0100, Stefan Richter wrote:
> > James Bottomley wrote:
> > >> >  struct attribute_group {
> > >> >  	const char		*name;
> > >> > +	int			(*filter_show)(struct kobject *, int);
> > 
> > > Actually, it returns a true/false value indicating whether the given
> > > attribute should be displayed.
> > 
> > How about this:
> > 
> > 	int (*is_visible)(...);
> 
> OK, so is this latest revision acceptable to everyone?

Acked-by: Kay Sievers <kay.sievers@vrfy.org>

Best,
Kay

