Return-Path: <linux-kernel-owner+w=401wt.eu-S1760996AbZE0Jv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760996AbZE0Jv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 05:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759733AbZE0JvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 05:51:19 -0400
Received: from mga06.intel.com ([134.134.136.21]:64329 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755794AbZE0JvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 05:51:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,258,1241420400"; 
   d="scan'208";a="416013622"
Date: Wed, 27 May 2009 11:53:28 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, holtmann@linux.intel.com,
       yi.zhu@intel.com, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] firmware: Allocate firmware id dynamically
Message-ID: <20090527095326.GD3777@sortiz.org>
References: <20090526140423.GA14683@sortiz.org> <ac3eb2510905260711hb273541i8d69128b88933f7f@mail.gmail.com> <20090526132351.9805f1e8.akpm@linux-foundation.org> <20090527115748.9ff0bad1.sfr@canb.auug.org.au> <20090527081732.GB3777@sortiz.org> <20090527091611.GA3986@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527091611.GA3986@tuxdriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 11:16:13AM +0200, John W. Linville wrote:
> On Wed, May 27, 2009 at 10:17:33AM +0200, Samuel Ortiz wrote:
> 
> > > next-20090526:drivers/net/wireless/p54/p54usb.c
> 
> > All of those have been taken care of by my last patch set, see:
> > http://lkml.org/lkml/2009/5/26/518
> > 
> > The p54usb one has been sent to John and linux-wireless as it's coming from
> > wireless-testing.
> 
> Is that patch dependent on other p54 bits in wireless-next-2.6?
The p54usb.c FIRMWARE_NAME_MAX reference was introduce with commit
1ca5f2e94c40b04d5dec437cd41fd5ba12aaac31 from your wireless-next-2.6 tree.

Cheers,
Samuel.

 
> John
> -- 
> John W. Linville		Someday the world will need a hero, and you
> linville@tuxdriver.com			might be all we have.  Be ready.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
