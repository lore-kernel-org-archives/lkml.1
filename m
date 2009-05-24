Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbZEXHTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbZEXHTr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 03:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbZEXHTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 03:19:38 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:3619 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbZEXHTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 03:19:38 -0400
Date: Sun, 24 May 2009 04:16:17 -0300
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC PATCH] bio-integrity: Copy bip_buf and bip_size in
	bio_integrity_clone()
Message-ID: <20090524071617.GH1376@blitiri.com.ar>
References: <20090524042035.GF1376@blitiri.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090524042035.GF1376@blitiri.com.ar>
User-Agent: Mutt/1.5.17 (2008-03-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 24, 2009 at 01:20:35AM -0300, Alberto Bertogli wrote:
> While at it, I found that bio_integrity_clone() does not clone neither bip_buf
> nor bip_size, which already copies the bvec, which should have the same data
> because it's allocated in bio_integrity_prep().

In case that makes sense, updating bip_buf and bip_size (if bip_buf is not
NULL) in bio_integrity_trim() does too, doesn't it?

Thanks a lot,
		Alberto

