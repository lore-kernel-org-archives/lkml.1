Return-Path: <linux-kernel-owner+w=401wt.eu-S1760697AbYBWJE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697AbYBWJE5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 04:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYBWJEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 04:04:39 -0500
Received: from po-out-1718.google.com ([72.14.252.152]:59452 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbYBWJEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 04:04:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=wHUvm3v8WzTe5vaDs0aDcggPLjKg0JMRADaCWEI/LerXDOU1zxYLr0EiKp186QNES7mmJrDasGt7vNgvHT/efLIn+raYw6zffVRMVyb406i5d2pbC87SLZPRlV3TxWy38SdkYvCN8Vc68i/bePotRnPxOjPb/9quC5RvtA/ScTs=
Date: Sat, 23 Feb 2008 16:59:44 +0800 (CST)
Message-Id: <20080223.165944.37229792.xiyou.wangcong@gmail.com>
To: adobriyan@gmail.com
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] (Resend) Use get_personality()
From: WANG Cong <xiyou.wangcong@gmail.com>
In-Reply-To: <20080223085101.GC2262@martell.zuzino.mipt.ru>
References: <12037544592096-git-send-email-xiyou.wangcong@gmail.com>
	<20080223085101.GC2262@martell.zuzino.mipt.ru>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 00/16] (Resend) Use get_personality()
Date: Sat, 23 Feb 2008 11:51:01 +0300
Message-ID: <20080223085101.GC2262@martell.zuzino.mipt.ru>

> On Sat, Feb 23, 2008 at 04:14:03PM +0800, WANG Cong wrote:
> > This patchset makes the macro get_personality function alike
> > and teaches code to use get_personality() instead of explicit
> > reference.
> > 
> > [I am sorry if you've received multiple copied of this, since
> >  my git-send-email doesn't work well. ]
> 
> Yes, but why? "current->personality" is way more understandable than
> your macro because task subject to dereference is very visible.

Use get_personality() can hide the task_struct internals a bit.

And I don't think using the macro to access it is less understandable.
Since 'current' won't be NULL, whether the dereference is visible is
not important.

Regards.
