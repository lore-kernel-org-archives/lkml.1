Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbXJWVVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbXJWVVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbXJWVUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:20:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432AbXJWVUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:20:39 -0400
Date: Tue, 23 Oct 2007 17:20:26 -0400
From: Dave Jones <davej@redhat.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, Adam Jackson <ajax@redhat.com>,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] Add eeprom_bad_csum_allow module option to e1000.
Message-ID: <20071023212026.GF7793@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jeff Garzik <jeff@garzik.org>,
	"Kok, Auke" <auke-jan.h.kok@intel.com>,
	Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
	David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>
References: <11931515302013-git-send-email-ajax@redhat.com> <471E1ECD.80002@intel.com> <1193156487.26974.39.camel@localhost.localdomain> <471E2AD0.1000500@intel.com> <471E5C21.8030908@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471E5C21.8030908@garzik.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 04:40:01PM -0400, Jeff Garzik wrote:

 > > In any case, this patch should not be merged. We often send it around to users to
 > > debug their issue in case it involves eeproms, but merging it will just conceal
 > > the real issue and all of a sudden a flood of people stop reporting *real* issues
 > > to us.
 > 
 > Sorry, I disagree.  Just as with e100, if there is a clear way the user 
 > can recover their setup -- and Adam says his was effective -- I don't 
 > see why we should be denying users the ability to use their own hardware.
 
Indeed. This is a common enough problem that not including it causes more pain
than its worth.  I have two affected boxes myself that I actually thought
the hardware was dead before I tried ajax's patch.

People aren't going to report this as a bug. They aren't going to try out patches,
they're going to do what I did and stick another network card in the box and
go on with life.

Our users deserve better than this.

	Dave

-- 
http://www.codemonkey.org.uk
