Return-Path: <linux-kernel-owner+w=401wt.eu-S1761676AbZD3Bvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761676AbZD3Bvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 21:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbZD3Bvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 21:51:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:32950 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361AbZD3Bvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 21:51:44 -0400
Message-ID: <49F903DD.8040707@kernel.org>
Date: Thu, 30 Apr 2009 10:50:21 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, Mauelshagen@RedHat.com,
       dm-devel@RedHat.com
Subject: Re: [PATCHSET] block,scsi,libata: implement alt_size
References: <1233456951-992-1-git-send-email-tj@kernel.org> <49F902CF.7080307@garzik.org>
In-Reply-To: <49F902CF.7080307@garzik.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Apr 2009 01:50:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Jeff Garzik wrote:
> <shrug>  I suppose...
> 
> It just seems like a nasty hack, but unfortunately I don't see
> anyone stepping up to do it properly -- with a DM device
> automatically layered on top that splits the device into separate
> regions: one block device for the 'regular' area, and one for the
> HPA.

Isn't that more hacky?  I don't know.  All that dm needs to know is
the location of the metadata which is located w.r.t. the end of the
device which might be at a different location if BIOS tried to pull
silly stunts.  So, exporting the size BIOS might have used seems like
a straight forward solution to me.

Thanks.

-- 
tejun
