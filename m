Return-Path: <linux-kernel-owner+w=401wt.eu-S1760625AbXKPQuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625AbXKPQuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 11:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbXKPQua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 11:50:30 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:34459 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbXKPQu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 11:50:29 -0500
Date: Fri, 16 Nov 2007 08:48:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Daniel Lezcano <dlezcano@fr.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Cedric Le Goater <clg@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH][DOCUMENTATION] The namespaces compatibility list doc
Message-Id: <20071116084820.cc8ccd19.randy.dunlap@oracle.com>
In-Reply-To: <473DBCC2.70506@fr.ibm.com>
References: <473D6434.5020201@openvz.org>
	<473DBCC2.70506@fr.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007 16:52:34 +0100 Daniel Lezcano wrote:

> > +1. Both the IPC and the PID namespaces provide IDs to address
> > +   object inside the kernel. E.g. semaphore with ipcid or
> > +   process group with pid.
> > +
> > +   In both cases, tasks shouldn't try exposing this id to some
> > +   other task living in a different namespace via a shared filesystem
> > +   or IPC shmem/message. The fact is that this ID is only valid
> > +   within the namespace it was obtained in and may refer to some
> > +   other object in another namespace.
> > +
> > +2. Intentionnaly, two equal user ids in different user namespaces
>        Intentionaly

        Intentionally,

> > +   should not be equal from the VFS point of view. In other
> > +   words, user 10 in one user namespace shouldn't have the same
> > +   access permissions to files, beloging to user 10 in another
>                                     belonging
> > +   namespace. But currently this is not so.
> > +

---
~Randy
