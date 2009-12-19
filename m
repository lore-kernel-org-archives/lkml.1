Return-Path: <linux-kernel-owner+w=401wt.eu-S1751153AbZLSJmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153AbZLSJmp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 04:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbZLSJmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 04:42:44 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:53921 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750800AbZLSJmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 04:42:43 -0500
Date: Sat, 19 Dec 2009 17:42:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Youquan,Song" <youquan.song@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com
Subject: Re: [PATCH]crypto: Fix complain about lack test for internal used
	algorithm
Message-ID: <20091219094240.GA21546@gondor.apana.org.au>
References: <200912101939.30446.david-b@pacbell.net> <20091211034711.GA2773@suse.de> <200912102013.59329.david-b@pacbell.net> <20091211043849.GA18007@suse.de> <1260509771.12346.138.camel@localhost> <20091211132321.GA17228@youquan-linux.bj.intel.com> <20091211060448.GA28704@gondor.apana.org.au> <20091219094043.GA23639@youquan-linux.bj.intel.com> <20091219022917.GA19431@gondor.apana.org.au> <20091219150736.GA5368@youquan-linux.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091219150736.GA5368@youquan-linux.bj.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 19, 2009 at 10:07:36AM -0500, Youquan,Song wrote:
> > No what I meant is that each algorithm should have its own nul
> > entry.  IOW we don't need this crypto_is_internal stuff at all.
> 
> Hi Herbert,
> 
> Well, Are you satisfied with the following modification?

Yes looks good to me.  Please resubmit with a proper changelog
and sign-off.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
