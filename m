Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbYKTRCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbYKTRCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 12:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757038AbYKTRBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 12:01:53 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:1962 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004AbYKTRBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 12:01:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NR1ATGbfenmpHuwRv9XnRkofphGTp7WwU2B3wcGd6yM/1mdXypvWUXisoF8hpDPTfu
         wyKXyG1j+PnF5hMHto5DOZlw58wbqZK0OGJQYEZiHpvP0baV5BGhQH3uVZrUS8dimQY8
         6D1iMcXCHx/HNyyCDSC3+6FoeSFsp/t3P06vI=
Date: Thu, 20 Nov 2008 20:01:48 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mm: slab - __cache_alloc NULL prefetch fix
Message-ID: <20081120170148.GD7363@localhost>
References: <20081120164400.GC7363@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120164400.GC7363@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Thu, Nov 20, 2008 at 07:44:00PM +0300]
| Do not prefetch NULL
| 
| Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| ---
| 
| Please check
|
...

even having prefetch(NULL) as valid we do check if
object is not NULL anyway so I thought there is no
need to prefetch(NULL) in case of fail.
 
		- Cyrill -
