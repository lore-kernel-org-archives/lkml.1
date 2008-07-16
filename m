Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbYGPTUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbYGPTUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 15:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbYGPTUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 15:20:43 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:64782 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbYGPTUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 15:20:42 -0400
Date: Wed, 16 Jul 2008 12:20:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>,
       jejb <James.Bottomley@HansenPartnership.com>, jaswinder@infradead.org
Subject: Re: [PATCH -next] scsi: fix advansys printk format warnings
Message-Id: <20080716122018.7720fda5.randy.dunlap@oracle.com>
In-Reply-To: <1216234773.1862.6.camel@shinybook.infradead.org>
References: <20080716115057.47b3e117.randy.dunlap@oracle.com>
	<1216234773.1862.6.camel@shinybook.infradead.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2008 11:59:33 -0700 David Woodhouse wrote:

> On Wed, 2008-07-16 at 11:50 -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Fix printk format warnings (firmware-related):
> > 
> > linux-next-20080716/drivers/scsi/advansys.c:4788: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
> > linux-next-20080716/drivers/scsi/advansys.c:5117: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
> > linux-next-20080716/drivers/scsi/advansys.c:5631: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
> > linux-next-20080716/drivers/scsi/advansys.c:6131: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
> 
> 
> Thanks. We'll roll those into the original patches, if that's OK with
> you.

Ack.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
