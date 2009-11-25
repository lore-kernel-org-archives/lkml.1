Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbZKYPGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbZKYPGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 10:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbZKYPGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 10:06:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52750 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbZKYPGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 10:06:17 -0500
To: "Liuweni" <qingshenlwy@gmail.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "strongzgy" <strongzgy@gmail.com>, "xgr178" <xgr178@163.com>,
       "Liu Hui" <onlyflyer@gmail.com>, "viro" <viro@zeniv.linux.org.uk>,
       "akpm" <akpm@linux-foundation.org>, "jack" <jack@suse.cz>,
       "npiggin" <npiggin@suse.de>,
       "linux-fsdevel" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1/3]fs/inode: iunique() Optimize Performance
From: Andi Kleen <andi@firstfloor.org>
References: <200911252209432039291@gmail.com>
Date: Wed, 25 Nov 2009 16:06:22 +0100
In-Reply-To: <200911252209432039291@gmail.com> (Liuweni's message of "Wed, 25 Nov 2009 22:09:45 +0800")
Message-ID: <87pr76ve35.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Liuweni" <qingshenlwy@gmail.com> writes:

> ---
> move the if condition out the while{}.
> While the function executing, the if 
> condition won't check again and again.
> And this code won't change the function
> of iunique().

Normally compiler automatically move loop invariant code out of loop
bodies. Have you verified that's not the case here?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
