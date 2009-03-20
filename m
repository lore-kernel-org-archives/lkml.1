Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbZCTIxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbZCTIxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 04:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757926AbZCTIxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 04:53:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757971AbZCTIxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 04:53:31 -0400
Date: Fri, 20 Mar 2009 04:53:27 -0400 (EDT)
From: Miloslav Trmac <mitr@redhat.com>
To: Paul Moore <paul.moore@hp.com>
Cc: viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-audit@redhat.com
Message-ID: <1666981128.1772561237539207343.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1446383553.1772511237538977759.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Subject: Re: [PATCH] Add SELinux context and TTY name to AUDIT_TTY records
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,
Thanks for your review.
----- "Paul Moore" <paul.moore@hp.com> wrote:
> There are several audit experts which should review this code but two
> things 
> jumped out at me when glancing at your patch:
> 
>  1. SELinux SIDs should not be recorded
Almost all code that logs SELinux contexts in kernel/audit* does the same thing as this patch, falling back to a SID if it can't be converted to a string.

>  2. From a SELinux/security point of view ttys are considered objects
>     and their labels/contexts should be recorded with "obj=" not
> "subj="
The patch logs the context of the process, not of the TTY.
    Mirek
