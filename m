Return-Path: <linux-kernel-owner+w=401wt.eu-S1756958AbZF0Slj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbZF0Slj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 14:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbZF0Sla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 14:41:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:34246 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbZF0Sl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 14:41:29 -0400
Subject: Re: [PATCH] SCSI: userspace cannot use scsi_command_size_tbl,
 COMMAND_SIZE and scsi_device_type
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Boaz Harrosh <bharrosh@panasas.com>,
       Benny Halevy <bhalevy@panasas.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       James Smart <James.Smart@Emulex.Com>
In-Reply-To: <20090627182821.GC5480@parisc-linux.org>
References: <1246122359.32198.7.camel@hpdv5.satnam>
	 <1246123628.3990.19.camel@mulgrave.site>
	 <1246125388.32198.14.camel@hpdv5.satnam>
	 <20090627182821.GC5480@parisc-linux.org>
Content-Type: text/plain
Date: Sun, 28 Jun 2009 00:10:39 +0530
Message-Id: <1246128039.32198.17.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-27 at 12:28 -0600, Matthew Wilcox wrote:
> On Sat, Jun 27, 2009 at 11:26:28PM +0530, Jaswinder Singh Rajput wrote:
> > > On Sat, 2009-06-27 at 22:35 +0530, Jaswinder Singh Rajput wrote:
> > > > userspace cannot use scsi_command_size_tbl, COMMAND_SIZE
> > > > and scsi_device_type defined in kernel
> 
> When did we start exporting include/scsi to userspace?  I thought glibc
> had its own separate definitions.
> 

commit 9e4f5e29610162fd426366f3b29e3cc6e575b858
Author: James Smart <James.Smart@Emulex.Com>
Date:   Thu Mar 26 13:33:19 2009 -0400

    [SCSI] FC Pass Thru support

--
JSR

