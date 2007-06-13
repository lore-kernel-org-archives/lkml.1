Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbXFMSt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbXFMSt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 14:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbXFMStW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 14:49:22 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43692 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbXFMStV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 14:49:21 -0400
Subject: Re: [RFC/PATCH] Documentation of kernel messages
From: Dave Hansen <hansendc@us.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: holzheu <holzheu@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, akpm@osdl.org, mtk-manpages@gmx.net,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
In-Reply-To: <20070613183200.GA16588@suse.de>
References: <1181747217.29512.9.camel@localhost.localdomain>
	 <20070613175147.GB14355@suse.de>
	 <1181758680.26375.25.camel@localhost.localdomain>
	 <20070613183200.GA16588@suse.de>
Content-Type: text/plain
Date: Wed, 13 Jun 2007 11:49:15 -0700
Message-Id: <1181760555.8735.17.camel@spirit>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-13 at 11:32 -0700, Greg KH wrote:
> 
> > dev_printk() and friends are great, since they already define
> something
> > like KMSG_COMPONENT: The driver name.
> 
> They provide way more than that, they also provide the explicit device
> that is being discussed, as well as other things depending on the
> device. 

Instead of keeping a list of kernel message ids somewhere, can you base
this off the dev_printk() format argument?

You could keep a list of those somewhere, extracted from the kernel
source, and correlate documentation with the _format_ instead of an
arbitrarily assigned message number.

-- Dave

