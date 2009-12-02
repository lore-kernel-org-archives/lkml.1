Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbZLBNVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbZLBNVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbZLBNVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:21:52 -0500
Received: from sorrow.cyrius.com ([65.19.161.204]:43967 "EHLO
	sorrow.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbZLBNVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:21:52 -0500
Date: Wed, 2 Dec 2009 13:21:47 +0000
From: Martin Michlmayr <tbm@cyrius.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Dave Airlie <airlied@linux.ie>, Thomas Hellstrom <thellstrom@vmware.com>,
       Jerome Glisse <jglisse@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH] DRM: Fix build error in include/drm/ttm/ttm_memory.h
Message-ID: <20091202132147.GM18101@deprecation.cyrius.com>
References: <20091202125651.GA19748@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202125651.GA19748@linux-mips.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ralf Baechle <ralf@linux-mips.org> [2009-12-02 12:56]:
> include/drm/ttm/ttm_memory.h uses struct page * without having included
> the required headers or a forward declaration resulting in the following
> build error for mtx1_defconfig on Linus' master branch, possibly others:

I sent such a patch several weeks ago but unfortunately it hasn't been
applied yet:
http://www.mail-archive.com/dri-devel@lists.sourceforge.net/msg44711.html

-- 
Martin Michlmayr
http://www.cyrius.com/
