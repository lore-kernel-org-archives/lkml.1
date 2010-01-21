Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747Ab0AURum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab0AURum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 12:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777Ab0AURuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 12:50:40 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:59101 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab0AURuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 12:50:39 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 21 Jan 2010 09:50:34 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Avi Kivity <avi@redhat.com>
cc: "Michael S. Tsirkin" <mst@redhat.com>, mtosatti@redhat.com,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 1/3] eventfd: allow atomic read and waitqueue remove
In-Reply-To: <4B58933C.4090209@redhat.com>
Message-ID: <alpine.DEB.2.00.1001210949280.8786@makko.or.mcafeemobile.com>
References: <20100121162648.GA16458@redhat.com> <alpine.DEB.2.00.1001210857310.8548@makko.or.mcafeemobile.com> <4B588B29.2050100@redhat.com> <20100121172336.GA16707@redhat.com> <4B588FCE.7030803@redhat.com> <20100121173259.GC16707@redhat.com>
 <4B58933C.4090209@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jan 2010, Avi Kivity wrote:

> On 01/21/2010 07:32 PM, Michael S. Tsirkin wrote:
> > 
> > > Can't you read from the file?
> > >      
> > IMO no, the read could block.
> >    
> 
> But you're in process context.  An eventfd never blocks.

Can you control the eventfd flags? Because if yes, O_NONBLOCK will never 
block.



- Davide


