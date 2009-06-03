Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbZFCWtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbZFCWtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 18:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbZFCWsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 18:48:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:9881 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578AbZFCWsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 18:48:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,300,1241420400"; 
   d="scan'208";a="418652842"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Organization: Intel Corporation
To: wimax@linuxwimax.org
Subject: Re: linux-next: Tree for June 3 (rfkill)
Date: Thu, 4 Jun 2009 06:48:11 +0800
User-Agent: KMail/1.9.9
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-wimax@intel.com,
       linux-next@vger.kernel.org
References: <20090603190952.2dd0cc70.sfr@canb.auug.org.au> <4A26B0D2.3090207@oracle.com> <1244050400.22105.0.camel@johannes.local>
In-Reply-To: <1244050400.22105.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906040648.11839.inaky@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 June 2009, Johannes Berg wrote:
> On Wed, 2009-06-03 at 10:20 -0700, Randy Dunlap wrote:
> > Ugh, there are similar errors in the wimax area, which doesn't
> > seem to mention RFKILL in its Kconfig file at all.  :(
>
> Guess it too will have to get a
>
> 	depends on RFKILL || !RFKILL
>
> I can take care of it after dinner.

Ugh...bitten again by Randy's evil autobuilder. Thanks for fixing
it, Johannes.

-- 
Inaky
