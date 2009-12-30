Return-Path: <linux-kernel-owner+w=401wt.eu-S1752338AbZL3Gx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbZL3Gx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 01:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbZL3Gx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 01:53:27 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:65114 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbZL3Gx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 01:53:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=anRyNYqTx+NZJ/Q5csTZJjGjKP3pivCsytJGQVFmJYpP2KYwHygrfb0gCqgiAKD5RP
         wa/FvEy9Yh2GxJgCs4BWdDKgXWgkkaSXsyDSIH6jB7Xra9ig6k/iSWSMqJg+6yxyDwzJ
         e8Oj+UQR0LjWqIaFMlnM/ye9kHcrPWBnKXwHE=
Date: Wed, 30 Dec 2009 07:53:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christian Kujau <lists@nerdbynature.de>, Yinghai Lu <yinghai@kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/4] Some reiserfs fixes
Message-ID: <20091230065321.GA32513@nowhere>
References: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 06:21:27AM +0100, Frederic Weisbecker wrote:
> Hi,
> 
> These patches should fix most of the lock inversions you've reported,
> plus some others I've encountered, except may be the one reported by
> Yinghai Lu that I'm still trying to reproduce.
> 
> I just hope these fixes won't enlight more lock inversions.
> 
> Anyway, please give it a try, your reports have been really helpful.



Actually please don't try it!

I just tested dbench with xattrs and got 5 more different lock
inversions (brought with soft lockups ;). I just fixed all of
them with 5 more patches, I just don't have pushed them yet,
waiting for a night in my bed before writing the changelogs.

Will push/post them tomorrow.

Thanks!

