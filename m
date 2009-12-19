Return-Path: <linux-kernel-owner+w=401wt.eu-S932716AbZLSC3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716AbZLSC3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 21:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755878AbZLSC3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 21:29:23 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:44093 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754490AbZLSC3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 21:29:22 -0500
Date: Sat, 19 Dec 2009 10:29:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Youquan,Song" <youquan.song@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com
Subject: Re: [PATCH]crypto: Fix complain about lack test for internal used
	algorithm
Message-ID: <20091219022917.GA19431@gondor.apana.org.au>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com> <200912101939.30446.david-b@pacbell.net> <20091211034711.GA2773@suse.de> <200912102013.59329.david-b@pacbell.net> <20091211043849.GA18007@suse.de> <1260509771.12346.138.camel@localhost> <20091211132321.GA17228@youquan-linux.bj.intel.com> <20091211060448.GA28704@gondor.apana.org.au> <20091219094043.GA23639@youquan-linux.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091219094043.GA23639@youquan-linux.bj.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 19, 2009 at 04:40:43AM -0500, Youquan,Song wrote:
>
> Do you like the following modification to the patch?
> If yes, I will resend the patch.

No what I meant is that each algorithm should have its own nul
entry.  IOW we don't need this crypto_is_internal stuff at all.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
