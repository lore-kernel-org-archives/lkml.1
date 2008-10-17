Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbYJQTu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbYJQTu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 15:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbYJQTur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 15:50:47 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:42609 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754731AbYJQTur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 15:50:47 -0400
X-YMail-OSG: vfw0mHUVM1mGA_QoN2llgLJVA1pTMr9LRN7kQGfDbd3HdMqSiMVVaSh8nH0H.2JREmGDvdYsu0R3JB56ONWvAavHIZVz6HPZ7RXgjWmuCWBIbapPmygKcJ5RSEGGT9VZuPXrmpEhYCi7tQ8Bzs8s2di9wbm6HsxyrX13L7g-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH] [ConfigFS]: Allow symbolic links from a SysFS struct
	kobject source.
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>,
       SCST-Devel <scst-devel@lists.sourceforge.net>,
       Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@osdl.org>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20081017193947.GC5633@mail.oracle.com>
References: <1224226555.5556.279.camel@haakon2.linux-iscsi.org>
	 <20081017193947.GC5633@mail.oracle.com>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 12:50:44 -0700
Message-Id: <1224273044.5556.353.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-17 at 12:39 -0700, Joel Becker wrote:
> On Thu, Oct 16, 2008 at 11:55:55PM -0700, Nicholas A. Bellinger wrote:
> > Hi Joel, Greg and Co,
> > 
> > Here is the the first working code for allowing configfs to handle
> > symlinks from sysfs struct kobject based code.  Here is the commit:
> > passing struct kobject into generic target_core_mod subsystem plugins
> > for locating struct block_device and struct scsi_device..  
> 
> NAK.
> 
> As Greg said, this just doesn't work.  Don't go down this path.
> 

Fair enough, I will kill it from my tree. :-)

Thanks for your comments!

--nab



