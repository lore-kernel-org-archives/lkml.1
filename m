Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259AbZCRJie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbZCRJie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 05:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293AbZCRJiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 05:38:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53777 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbZCRJiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 05:38:24 -0400
Date: Wed, 18 Mar 2009 05:38:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: VIRTIO_BLK_T_SCSI_CMD handling in virtio-blk
Message-ID: <20090318093819.GA26724@infradead.org>
References: <20090318060919.GA21777@infradead.org> <200903180947.36878.borntraeger@de.ibm.com> <49C0BBFB.5040605@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C0BBFB.5040605@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah nice.  Still needs some work to make the SG_IO submission async
and abstrat the Linux-specific ioctl out of the common virtio-blk.c
code, but that should be a fallout of the scsi-generic layer I'm hacking
on for qemu now.

