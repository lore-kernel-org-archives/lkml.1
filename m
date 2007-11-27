Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbXK0VQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbXK0VQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 16:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756891AbXK0VQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 16:16:49 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48356 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757573AbXK0VQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 16:16:48 -0500
Date: Tue, 27 Nov 2007 13:16:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: casey@schaufler-ca.com
Cc: torvalds@linux-foundation.org, morgan@kernel.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] -mm (2.4.26-rc3-mm1) v2  Smack using capabilities 32
 and 33
Message-Id: <20071127131632.808bf9f8.akpm@linux-foundation.org>
In-Reply-To: <474B2EE0.5080102@schaufler-ca.com>
References: <474B2EE0.5080102@schaufler-ca.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007 12:38:56 -0800
Casey Schaufler <casey@schaufler-ca.com> wrote:

> From: Casey Schaufler <casey@schaufler-ca.com>
> 
> This patch takes advantage of the increase in capability bits
> to allocate capabilities for Mandatory Access Control. Whereas
> Smack was overloading a previously allocated capability it is
> now using a pair, one for overriding access control checks and
> the other for changes to the MAC configuration.
> 
> The two capabilities allocated should be obvious in their intent.
> The comments in capability.h are intended to make it clear that
> there is no intention that implementations of MAC LSM modules
> be any more constrained by the presence of these capabilities
> than an implementation of DAC LSM modules are by the analogous
> DAC capabilities.
> 
> 
> +		!__capable(current, CAP_MAC_ADMIN))
> +		!__capable(current, CAP_MAC_ADMIN))

Is there any reason for not using plain old capable() here?
