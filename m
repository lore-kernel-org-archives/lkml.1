Return-Path: <linux-kernel-owner+w=401wt.eu-S1761775AbYBAWo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761775AbYBAWo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 17:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756404AbYBAWor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 17:44:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48523 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760042AbYBAWoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 17:44:46 -0500
Date: Fri, 1 Feb 2008 14:33:17 -0800
From: Greg KH <greg@kroah.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk,
       "Ed L. Cashin" <ecashin@coraid.com>
Subject: Re: [Patch 0/6] Enhanced partition statistics
Message-ID: <20080201223317.GD8529@kroah.com>
References: <47A3616F.20305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A3616F.20305@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 07:14:07PM +0100, Jerome Marchand wrote:
> Hi,
> 
> This patchset is the corrected version of the patchset I posted
> here weeks ago and which brings back the I/O statistics concerning
> partitions which were lost between 2.4 and 2.6 kernels.
> 
> This version still breaks the /sys/block/_disk_/_part_/stat and
> /proc/diskstats interfaces. Incidentally iostat is already able to
> deal correctly with the new format and both 'iostat -x' and
> 'iostat -p' already display the enhanced partition statistics.

As you are changing a userspace ABI, please document it properly in
Documentation/ABI/ when you change it.

thanks,

greg k-h
