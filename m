Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbZH3ROl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbZH3ROl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 13:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbZH3ROk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 13:14:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46615 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbZH3ROk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 13:14:40 -0400
Date: Sun, 30 Aug 2009 13:14:38 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, liml@rtr.ca,
       jens.axboe@oracle.com, matthew@wil.cx, dwmw2@infradead.org
Subject: Re: [PATCH 4/7] sd: add support for WRITE SAME (16) with unmap bit
Message-ID: <20090830171438.GA12178@infradead.org>
References: <20090829230332.017137693@bombadil.infradead.org> <20090829231121.713422216@bombadil.infradead.org> <4A9A5E89.7070204@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9A5E89.7070204@ru.mvista.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 03:12:09PM +0400, Sergei Shtylyov wrote:
>> +	printk(KERN_INFO "umap, lba = 0x%lld, len = %d\n",
>>   
>
>   So, is it hex or decimal? :-)
>
>> +	       bio->bi_sector, bio_sectors(bio));
>>   
>
>   Since bio->bi_sector can either be 4 or 8 bytes, you need a cast to  
> unsigned long long here.

Indeed.  But as this is justa debug printk that slipped through I will
just remove it completely in the next iteration.

