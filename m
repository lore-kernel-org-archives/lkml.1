Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935339Ab0B1Snz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 13:43:55 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:60023 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932165Ab0B1Sny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 13:43:54 -0500
Date: Sun, 28 Feb 2010 19:43:53 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, james.bottomley@suse.de,
       linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com,
       linux-scsi@vger.kernel.org, brace@beardog.cce.hp.com
Subject: Re: [PATCH 0/9] cciss driver SCSI updates
Message-ID: <20100228184353.GG5768@kernel.dk>
References: <20100226220023.11979.4999.stgit@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100226220023.11979.4999.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26 2010, Stephen M. Cameron wrote:
> The following series mainly fixes the scsi tape code in the cciss
> driver to take advantage of more scatter gather elements, enabling
> larger transfer sizes.  The first eight patches are mainly cleaning
> things up and getting ready for the 9th patch, which enables the
> SCSI half of the driver to use more than 31 scatter gather elements.
> 
> I've tested on 32-bit and 64-bit systems, and written out tapes
> with block sizes up to 2Mb.
> 
> These patches are vs. Jens's linux-2.6-block tree.

Thanks Stephen, applied.

-- 
Jens Axboe

