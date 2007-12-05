Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbXLEVEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbXLEVEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 16:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbXLEVER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 16:04:17 -0500
Received: from bebe.enoyolf.org ([24.173.215.190]:60429 "EHLO bebe.enoyolf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbXLEVER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 16:04:17 -0500
X-Mailer: exmh enoyolf.org version 2.7.2.1 01/17/2005 with nmh-1.1
In-reply-to: <20071205204046.GA2898@andromeda.dapyr.net> 
References: <20071128233422.GD6736@andromeda.dapyr.net> <20071205004418.GH6736@andromeda.dapyr.net> <22081.1196824331@bebe.enoyolf.org> <20071205174121.GA1801@andromeda.dapyr.net> <1797.1196886400@bebe.enoyolf.org>  <20071205204046.GA2898@andromeda.dapyr.net> 
To: Konrad Rzeszutek <konrad@darnok.org>
cc: Mike Christie <michaelc@cs.wisc.edu>, darnok@68k.org,
       linux-kernel@vger.kernel.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, greg@kroah.com, randy.dunlap@oracle.com,
       hpa@zytor.com, lenb@kernel.org, mike.anderson@us.ibm.com,
       dwm@austin.ibm.com, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [REPOST PATCH] Add iSCSI IBFT support (v0.4) 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 05 Dec 2007 15:02:56 -0600
Message-ID: <9524.1196888576@bebe.enoyolf.org>
From: Doug Maxey <dwm@enoyolf.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[added cc: to mikec]

On Wed, 05 Dec 2007 16:40:46 -0400, Konrad Rzeszutek wrote:
> On Wed, Dec 05, 2007 at 02:26:40PM -0600, Doug Maxey wrote:
> > 
> > On Wed, 05 Dec 2007 13:41:21 -0400, Konrad Rzeszutek wrote:
> > > > Is the current include from open-iscsi being duplicated?  If not, why
> > > > not consolidate in one file?
> > > 
> > > The include files that come from open-iscsi that are in the kernel do
> > > not have the iBFT data structures in them - therefore no duplication.
> > 
> > That is strictly true, at least the "in the kernel" part.  There is a 
> > file with the definitions, open-iscsi utils/fwparam_ibft/fwparam_ibft.h 
> > does have the previous definitons.  So what to do?  Drop that one?  Or 
> > keep duplicating?
> 
> I would say that utils/fwparam_ibft/fwparam_ibft.h and
> utils/fwparam_ibft/fwparam_ibft.c would be dropped once this kernel
> patch and the patch to open-iscsi to add fwparam_ibft_subsys.c are
> reviewed and hopefully accepted.
> 

Ok.  If indeed the userspace tool is going completely away, then there 
would be just the single instance.  Is that the plan?


