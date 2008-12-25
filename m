Return-Path: <linux-kernel-owner+w=401wt.eu-S1752232AbYLYKsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbYLYKsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 05:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbYLYKsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 05:48:09 -0500
Received: from mga14.intel.com ([143.182.124.37]:5394 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbYLYKsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 05:48:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,281,1228118400"; 
   d="scan'208";a="93816362"
Date: Thu, 25 Dec 2008 18:47:53 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: cannot reliably detect USB device
Message-ID: <20081225104753.GB15733@localhost>
References: <20081222084249.GA5845@localhost> <20081223043714.GH1928@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081223043714.GH1928@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 06:37:14AM +0200, Greg KH wrote:
> On Mon, Dec 22, 2008 at 04:42:49PM +0800, Wu Fengguang wrote:
> > Hi Greg,
> > 
> > I have a pl2303 USB-RS232 converter that cannot be reliably detected.
> 
> Faulty hardware?  Flaky cables?  Bad connections?  If this is
> reproducable for the same device on multiple machines, I'd just go buy a
> new device :)

I decided to give it a last try before planning a replacement - then I
find that /dev/ttyUSB0 could be created if I enlarge the retry times.

It could take 10 seconds to get a valid response. It must go crazy.

Thanks,
Fengguang

