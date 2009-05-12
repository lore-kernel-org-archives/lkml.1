Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbZELTK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbZELTK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 15:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZELTKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 15:10:09 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41578 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbZELTKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 15:10:07 -0400
Date: Tue, 12 May 2009 15:09:59 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] crypto: skip algs not flagged fips_allowed in
	fips mode
Message-ID: <20090512190959.GG5019@hmsreliant.think-freely.org>
References: <200905110953.06678.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905110953.06678.jarod@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 09:53:06AM -0400, Jarod Wilson wrote:
> Because all fips-allowed algorithms must be self-tested before they
> can be used, they will all have entries in testmgr.c's alg_test_descs[].
> Skip self-tests for any algs not flagged as fips_approved and return
> -EINVAL when in fips mode.
> 
> Resending with properly updated patch v2 tag.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> 
