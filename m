Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbYFDI7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbYFDI7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 04:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYFDI7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 04:59:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60125 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbYFDI7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 04:59:13 -0400
Subject: Re: [PATCH] add a printk_init variant storing format strings in
	__initdata
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, David Brownell <david-b@pacbell.net>,
       pavel@suse.cz, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, mingo@elte.hu
In-Reply-To: <20080604011607.15dec5a7.akpm@linux-foundation.org>
References: <20080529162257.03426e48.akpm@linux-foundation.org>
	 <1212485252.0@pinky>  <20080604011607.15dec5a7.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 09:59:09 +0100
Message-Id: <1212569949.4042.56.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-04 at 01:16 -0700, Andrew Morton wrote:
> We're going to want to be able to call printk_init() from modules. 
> Please fix and test that, if we decide to proceed.

Can we fix that by making it an alias for printk in the module case?

The only reason we need it to be __init is so that we get the section
warnings when you use it from non-init code, right? Won't we get the
warning when non-init code refers to the string in initdata anyway?

-- 
dwmw2

