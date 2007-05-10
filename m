Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbXEJLIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbXEJLIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbXEJLIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:08:47 -0400
Received: from mr.exanet.com ([212.143.73.109]:46896 "EHLO mr.exanet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbXEJLIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:08:47 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] interface for doing a full host scsi rescan
Date: Thu, 10 May 2007 14:08:34 +0300
Message-ID: <A6FDE6B975803043804A49F12F49028E0F59CD@hawk.exanet-il.co.il>
In-Reply-To: <20070510100929.GA13771@infradead.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] interface for doing a full host scsi rescan
Thread-Index: AceS606hHslH96DETHiCyrR0lVDEvgACDe3w
From: "Menny Hamburger" <menny@exanet.com>
To: "Christoph Hellwig" <hch@infradead.org>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thnx,

I'll check that

M. 

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Thursday, May 10, 2007 12:10 PM
To: Menny Hamburger
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] interface for doing a full host scsi rescan

On Thu, May 10, 2007 at 01:01:55PM +0300, Menny Hamburger wrote:
> Hi,
> 
> When we do want to rescan the SCSI host, a userland script needs to be

> provided that does add/remove.
> This patch adds an interface for doing this inside the kernel - seems 
> more appropriate:

/proc/scsi/scsi is deprecated, don't use it.  But you can do a full
rescan through /sys/.../scan

