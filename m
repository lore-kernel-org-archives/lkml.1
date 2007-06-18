Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbXFRE6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbXFRE6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 00:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758207AbXFRE6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 00:58:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47235 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755947AbXFRE6V (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 00:58:21 -0400
Date: Mon, 18 Jun 2007 14:57:59 +1000
From: David Chinner <dgc@sgi.com>
To: Neil Brown <neilb@suse.de>
Cc: Avi Kivity <avi@argo.co.il>, david@lang.hm, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: limits on raid
Message-ID: <20070618045759.GD85884050@sgi.com>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <467273AB.9010202@argo.co.il> <18035.3009.568832.785308@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18035.3009.568832.785308@notabene.brown>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2007 at 07:59:29AM +1000, Neil Brown wrote:
> Combining these thoughts, it would make a lot of sense for the
> filesystem to be able to say to the block device "That blocks looks
> wrong - can you find me another copy to try?".  That is an example of
> the sort of closer integration between filesystem and RAID that would
> make sense.

I think that this would only be useful on devices that store
discrete copies of the blocks on different devices i.e. mirrors. If
it's an XOR based RAID, you don't have another copy you can
retreive....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
