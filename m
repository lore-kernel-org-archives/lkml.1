Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbXF0QWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbXF0QWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbXF0QWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:22:40 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2236 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752218AbXF0QWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:22:39 -0400
Date: Thu, 28 Jun 2007 00:22:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: [md-accel PATCH 03/19] xor: make 'xor_blocks' a library routine for use with async_tx
Message-ID: <20070627162231.GA14606@gondor.apana.org.au>
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com> <20070627015049.18962.54083.stgit@dwillia2-linux.ch.intel.com> <a781481a0706262339w4c92e295s62a6c041dd1e9666@mail.gmail.com> <e9c3a7c20706270913v64ff933aj11e4bb227268311c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9c3a7c20706270913v64ff933aj11e4bb227268311c@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 09:13:21AM -0700, Dan Williams wrote:
> 
> The hope is that other subsystems beyond md could benefit from offload
> engines.  For example, the crc32c calculations in btrfs might be a
> good candidate, and kcopyd integration has crossed my mind.

Yes hopefully we will actually integrate this into the crypto API
(as an async operation) at some point so having them in crypto/
does make sense.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
