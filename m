Return-Path: <linux-kernel-owner+w=401wt.eu-S936311AbYBUX4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936311AbYBUX4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964951AbYBUXz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:55:59 -0500
Received: from [198.99.130.12] ([198.99.130.12]:44821 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S964944AbYBUXz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:55:58 -0500
Date: Thu, 21 Feb 2008 18:54:56 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: roland@redhat.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [bug] uml doesn't boot under 2.6.25-rc1 host (was Re: 2.6.24-mm1 bugs)
Message-ID: <20080221235456.GA11137@c2.user-mode-linux.org>
References: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu> <20080215184741.GB8810@c2.user-mode-linux.org> <E1JQ6bM-0005z4-Ac@pomaz-ex.szeredi.hu> <E1JRD9I-0004L9-6E@pomaz-ex.szeredi.hu> <E1JSF5r-0007vI-1v@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JSF5r-0007vI-1v@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 06:20:23PM +0100, Miklos Szeredi wrote:
> Bisected it down to
> 
> good e7b5e11eaaa8ef93a34e68016de51152d0d62911
> bad  bde6f5f59c2b2b48a7a849c129d5b48838fe77ee
> 
> I strongly suspect it's one of the ptrace cleanup patches.  Roland,
> could you please have a look?

I agree.  There's an awful lot of ptrace stuff in that range, and some
of it apparently broke 32-bit compatibility.

Thanks for chasing it down.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
