Return-Path: <linux-kernel-owner+w=401wt.eu-S1757027AbZGAE6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027AbZGAE6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 00:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbZGAE5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 00:57:54 -0400
Received: from ozlabs.org ([203.10.76.45]:50771 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbZGAE5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 00:57:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Jan Beulich" <JBeulich@novell.com>
Subject: Re: [PATCH] replace various uses of num_physpages by totalram_pages
Date: Wed, 1 Jul 2009 14:27:52 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <4A4A0E50020000780000830B@vpn.id2.novell.com>
In-Reply-To: <4A4A0E50020000780000830B@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907011427.52943.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 08:38:32 pm Jan Beulich wrote:
> Sizing of memory allocations shouldn't depend on the number of physical
> pages found in a system, as that generally include (perhaps a huge
> amount of) non-RAM pages. The amount of what actually is usable as
> storage should instead be used as a basis here.

I like this patch.  Where's num_physpages used after this: should it be an 
arch-specific or even a static?

FWIW: Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.
