Return-Path: <linux-kernel-owner+w=401wt.eu-S1759303AbYABPJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303AbYABPJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 10:09:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbYABPJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 10:09:41 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:54199 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbYABPJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 10:09:41 -0500
Date: Wed, 2 Jan 2008 10:09:15 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uml: user of helper_wait() got missed when it got extra arguments
Message-ID: <20080102150915.GC5567@c2.user-mode-linux.org>
References: <E1J6X0S-0007SZ-Aa@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1J6X0S-0007SZ-Aa@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2007 at 08:01:04PM +0000, Al Viro wrote:
> -		helper_wait(pid);
> +		helper_wait(pid, 1, NULL);

Thanks.

I know I fixed these - I probably forgot to quilt add the file.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
