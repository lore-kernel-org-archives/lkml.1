Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbXK1SaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbXK1SaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbXK1SaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:30:01 -0500
Received: from [198.99.130.12] ([198.99.130.12]:42704 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbXK1SaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:30:00 -0500
Date: Wed, 28 Nov 2007 13:29:35 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: mingo@elte.hu, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: -rt doesn't compile for UML
Message-ID: <20071128182935.GA8048@c2.user-mode-linux.org>
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128150637.GA5518@c2.user-mode-linux.org> <E1IxOwS-000752-HF@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IxOwS-000752-HF@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 04:35:12PM +0100, Miklos Szeredi wrote:
> Something like:
> 
>   dd if=/host/tmp/bigfile of=/tmp/bigfile bs=1048576 count=100
> 
> and run 'top' or 'watch something' in another terminal, which
> sometimes completely stops updating during the write.

Are you talking about missing updates for a few seconds, or for
longer?  With the common above, with top -delay 1, and with 600M of
data, I'm seeing occasional 2-3 pauses, with one missing 5 seconds.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
