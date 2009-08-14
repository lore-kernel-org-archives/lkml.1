Return-Path: <linux-kernel-owner+w=401wt.eu-S1756583AbZHNBBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbZHNBBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 21:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570AbZHNBBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 21:01:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:53310 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756244AbZHNBBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 21:01:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,377,1246863600"; 
   d="scan'208";a="541217673"
Subject: Re: [BUGFIX] crypto: Fix ctr(aes) testing by specifying geniv
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <20090813131253.GA27289@gondor.apana.org.au>
References: <1249285483-22286-1-git-send-email-ying.huang@intel.com>
	 <20090805094506.GA12528@gondor.apana.org.au>
	 <1249524767.24238.318.camel@yhuang-dev.sh.intel.com>
	 <1250044020.5337.214.camel@yhuang-dev.sh.intel.com>
	 <20090813045300.GA19993@gondor.apana.org.au>
	 <20090813073910.GA21784@gondor.apana.org.au>
	 <20090813131253.GA27289@gondor.apana.org.au>
Content-Type: text/plain
Date: Fri, 14 Aug 2009 09:01:07 +0800
Message-Id: <1250211667.5337.288.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 21:12 +0800, Herbert Xu wrote:
> On Thu, Aug 13, 2009 at 05:39:10PM +1000, Herbert Xu wrote:
> > 
> > Oh I see what's going on.  It's the switch from chainiv to eseqiv
> > that created the error.  I'll apply your patch.
> 
> Actually we can't use seqiv on raw counter mode because it cannot
> guarantee IV uniqueness.  I think reverting to chainiv is the safer
> option.


I see seqiv is used in rfc3686 mode, it means seqiv can not be used on
raw counter mode but can be used for rfc3686?

Best Regards,
Huang Ying

