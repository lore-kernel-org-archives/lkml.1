Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbXIQQRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbXIQQRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 12:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbXIQQRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 12:17:32 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:49481 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbXIQQRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 12:17:31 -0400
Date: Mon, 17 Sep 2007 20:17:07 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Sean Hefty <mshefty@ichips.intel.com>
Cc: Steve Wise <swise@opengridcomputing.com>, netdev@vger.kernel.org,
       rdreier@cisco.com, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
Subject: Re: [ofa-general] Re: [PATCH v2] iw_cxgb3: Support "iwarp-only" interfaces to avoid 4-tuple conflicts.
Message-ID: <20070917161706.GA28431@2ka.mipt.ru>
References: <20070913191617.30937.95960.stgit@dell3.ogc.int> <20070914130941.GG18517@2ka.mipt.ru> <46EC00BE.3020801@opengridcomputing.com> <46EEA6A2.2080001@ichips.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EEA6A2.2080001@ichips.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 09:09:06AM -0700, Sean Hefty (mshefty@ichips.intel.com) wrote:
> >>>+    addr = kmalloc(sizeof *addr, GFP_KERNEL);
> >>
> >>As a small nitpick: this wants to be sizeof(struct in_ifaddr)
> 
> See chapter 14 of CodingStyle document.  kmalloc(sizeof *addr... is correct.

Come on, do not start a flame war about how parameters into kmalloc
should be provided - there are much more serious issues unresolved yes. It
does help grepping the code, but if you feel that this is a serious threat,
then use your preferred way.

-- 
	Evgeniy Polyakov
