Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbYG2XSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbYG2XSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 19:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYG2XSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 19:18:44 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:45530 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbYG2XSn (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 19:18:43 -0400
Date: Wed, 30 Jul 2008 09:18:42 +1000
From: Simon Horman <horms@verge.net.au>
To: Mike Travis <travis@sgi.com>
Cc: Linux-kernel <Linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: Regression on ia64 with cpu masks: optimize and clean up
	cpumask_of_cpu()
Message-ID: <20080729231842.GH6370@verge.net.au>
References: <20080729034459.GA11699@verge.net.au> <20080729095001.GA509@verge.net.au> <488F3832.8010007@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488F3832.8010007@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 08:33:06AM -0700, Mike Travis wrote:
> Check linux-next, I believe the exact same fix is in there.  Apparently,
> as Stephen and others have pointed out earlier, that syntax isn't evaluated 
> correctly in earlier gcc's (at least earlier then the 4. series).

Thanks, confirmed.

dde108a23e4bf6d6d225ae18c64abeaf85fe2b50 in linux-next includes
the same fix that I stumbled upon.

-- 
Horms

