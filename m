Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbZCTNvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbZCTNvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 09:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZCTNvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 09:51:31 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:8793 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbZCTNva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 09:51:30 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH] Add SELinux context and TTY name to AUDIT_TTY records
Date: Fri, 20 Mar 2009 09:51:25 -0400
User-Agent: KMail/1.11.1 (Linux/2.6.27-gentoo-r8; KDE/4.2.1; i686; ; )
Cc: viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>, linux-audit@redhat.com
References: <1666981128.1772561237539207343.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1666981128.1772561237539207343.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903200951.25699.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 March 2009 04:53:27 am Miloslav Trmac wrote:
> ----- "Paul Moore" <paul.moore@hp.com> wrote:
> > There are several audit experts which should review this code but two
> > things jumped out at me when glancing at your patch:
> >
> >  1. SELinux SIDs should not be recorded
>
> Almost all code that logs SELinux contexts in kernel/audit* does the same
> thing as this patch, falling back to a SID if it can't be converted to a
> string.

Ungh, that's ugly and questionably useful (I suppose I know why this is done) 
but if that convention then who am I to argue.

> >  2. From a SELinux/security point of view ttys are considered objects
> >     and their labels/contexts should be recorded with "obj=" not
> > "subj="
>
> The patch logs the context of the process, not of the TTY.

Okay, that is what I get for just glancing at patches and not looking at them 
closer :)

-- 
paul moore
linux @ hp

