Return-Path: <linux-kernel-owner+w=401wt.eu-S935872AbXHOWPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935872AbXHOWPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 18:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758790AbXHOWOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 18:14:35 -0400
Received: from namei.org ([69.55.235.186]:38427 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756323AbXHOWOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 18:14:33 -0400
Date: Wed, 15 Aug 2007 15:13:55 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: linux-kernel@vger.kernel.org
cc: mm-commits@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       alan@redhat.com, jmorris@redhat.com, ranma+kernel@tdiedrich.de,
       wfg@mail.ustc.edu.cn, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@redhat.com>
Subject: Re: + fix-null-pointer-dereference-in-__vm_enough_memory.patch added
 to -mm tree
In-Reply-To: <200708152048.l7FKm0V5014219@imap1.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708151513160.20119@us.intercode.com.au>
References: <200708152048.l7FKm0V5014219@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007, akpm@linux-foundation.org wrote:

> ------------------------------------------------------
> Subject: fix NULL pointer dereference in __vm_enough_memory()
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> 
> The new exec code inserts an accounted vma into an mm struct which is not
> current->mm.  The existing memory check code has a hard coded assumption
> that this does not happen as does the security code.
> 
> As the correct mm is known we pass the mm to the security method and the
> helper function.  A new security test is added for the case where we need
> to pass the mm and the existing one is modified to pass current->mm to
> avoid the need to change large amounts of code.
> 
> (Thanks to Tobias for fixing rejects and testing)
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> Cc: WU Fengguang <wfg@mail.ustc.edu.cn>
> Cc: James Morris <jmorris@redhat.com>
> Cc: Tobias Diedrich <ranma+kernel@tdiedrich.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: James Morris <jmorris@namei.org>



-- 
James Morris
<jmorris@namei.org>
