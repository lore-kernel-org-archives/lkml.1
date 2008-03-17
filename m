Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbYCQWhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbYCQWhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 18:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbYCQWg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 18:36:59 -0400
Received: from ozlabs.org ([203.10.76.45]:36881 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbYCQWg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 18:36:59 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] fix verify_export_symbols()
Date: Tue, 18 Mar 2008 09:36:04 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
References: <47D8FC21.76E4.0078.0@novell.com>
In-Reply-To: <47D8FC21.76E4.0078.0@novell.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803180936.04586.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008 20:04:17 you wrote:
> When the newer export flavors were added, it was apparently forgotten
> to add respective code here.
> In order to not double the (source) size of the function, add some
> abstraction to reduce code duplication.

Hi Jan,

   Actually, the others did exist, they just weren't checked.

I've taken this patch and your two other module patches.  Please cc me on 
module patches in future.

Thanks!
Rusty.
