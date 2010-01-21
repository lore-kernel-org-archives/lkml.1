Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695Ab0AURxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab0AURxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 12:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579Ab0AURxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 12:53:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546Ab0AURxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 12:53:20 -0500
Date: Thu, 21 Jan 2010 19:50:15 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 1/3] eventfd: allow atomic read and waitqueue remove
Message-ID: <20100121175014.GI16707@redhat.com>
References: <20100121162648.GA16458@redhat.com> <alpine.DEB.2.00.1001210857310.8548@makko.or.mcafeemobile.com> <4B588B29.2050100@redhat.com> <20100121172336.GA16707@redhat.com> <4B588FCE.7030803@redhat.com> <20100121173259.GC16707@redhat.com> <4B58933C.4090209@redhat.com> <alpine.DEB.2.00.1001210949280.8786@makko.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1001210949280.8786@makko.or.mcafeemobile.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 09:50:34AM -0800, Davide Libenzi wrote:
> On Thu, 21 Jan 2010, Avi Kivity wrote:
> 
> > On 01/21/2010 07:32 PM, Michael S. Tsirkin wrote:
> > > 
> > > > Can't you read from the file?
> > > >      
> > > IMO no, the read could block.
> > >    
> > 
> > But you're in process context.  An eventfd never blocks.
> 
> Can you control the eventfd flags? Because if yes, O_NONBLOCK will never 
> block.
> 

Userspace can but kvm can't.

> 
> - Davide
> 
