Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbYIETzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbYIETzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 15:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYIETyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 15:54:55 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:31892 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbYIETyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 15:54:54 -0400
Message-ID: <48C18E8B.9050201@ct.jp.nec.com>
Date: Fri, 05 Sep 2008 12:54:51 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH -mm] Fix dev_load() compilation again
References: <20080904224004.d3dd3076.akpm@linux-foundation.org> <20080905193244.GD11569@x200.localdomain>
In-Reply-To: <20080905193244.GD11569@x200.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> dev_load() doesn't exist if MODULES=n.

Hi,

in -next tree, this patch fixes the compilation error instead of
my patch. So, there is a conflict.

commit 9b90dc7bc3079376567fc501e2e84751fa4040fd
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Wed Aug 27 14:45:37 2008 +1000

    rr: build fix for remove CONFIG_KMOD from net

    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

thanks,
Hiroshi Shimamoto
