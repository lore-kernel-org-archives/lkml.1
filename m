Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbYJQTmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbYJQTmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 15:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755712AbYJQTlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 15:41:52 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:64111 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbYJQTlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 15:41:51 -0400
Date: Fri, 17 Oct 2008 12:39:47 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>,
       SCST-Devel <scst-devel@lists.sourceforge.net>,
       Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@osdl.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [ConfigFS]: Allow symbolic links from a SysFS struct
	kobject source.
Message-ID: <20081017193947.GC5633@mail.oracle.com>
Mail-Followup-To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
	Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
	Linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-scsi <linux-scsi@vger.kernel.org>,
	"Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>,
	SCST-Devel <scst-devel@lists.sourceforge.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andrew Morton <akpm@osdl.org>,
	Christoph Hellwig <hch@infradead.org>
References: <1224226555.5556.279.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224226555.5556.279.camel@haakon2.linux-iscsi.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 11:55:55PM -0700, Nicholas A. Bellinger wrote:
> Hi Joel, Greg and Co,
> 
> Here is the the first working code for allowing configfs to handle
> symlinks from sysfs struct kobject based code.  Here is the commit:
> passing struct kobject into generic target_core_mod subsystem plugins
> for locating struct block_device and struct scsi_device..  

NAK.

As Greg said, this just doesn't work.  Don't go down this path.

Joel

-- 

"I always thought the hardest questions were those I could not answer.
 Now I know they are the ones I can never ask."
			- Charlie Watkins

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
