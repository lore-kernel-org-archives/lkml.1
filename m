Return-Path: <linux-kernel-owner+w=401wt.eu-S1759552AbXH3LR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552AbXH3LR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 07:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755670AbXH3LRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 07:17:49 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:60032 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbXH3LRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 07:17:48 -0400
Date: Thu, 30 Aug 2007 05:17:47 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: andre@finow14.de
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk
Subject: Re: [KJ][patch 3/3] VIDC20: use abs() from kernel.h instead of own definition
Message-ID: <20070830111746.GS14130@parisc-linux.org>
References: <20070830102551.131398783@finow14.de> <20070830104038.GD14925@ahaupt-debian-vm.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070830104038.GD14925@ahaupt-debian-vm.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 12:40:38PM +0200, andre@finow14.de wrote:
> -		diff_int = my_abs(rate_ext-rate);
> -		diff_ext = my_abs(rate_int-rate);
> +		diff_int = abs(rate_ext-rate);
> +		diff_ext = abs(rate_int-rate);

Nothing to do with the patch, but is this really correct?  Surely it
should be diff_ext = abs(rate_ext-rate) ?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
