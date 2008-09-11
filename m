Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbYIKJDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbYIKJDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 05:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbYIKJCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 05:02:50 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:60215 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbYIKJCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 05:02:49 -0400
Message-ID: <48C8DEA0.9080905@fr.ibm.com>
Date: Thu, 11 Sep 2008 11:02:24 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: chucklever@gmail.com, "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>, linux-nfs@vger.kernel.org
Subject: Re: [RFC][PATCH] sunrpc: fix oops in rpc_create() when the mount
 namespace is unshared
References: <48C52B29.4020204@fr.ibm.com> <20080909124311.GA10053@us.ibm.com> <m18wu1nyon.fsf@frodo.ebiederm.org> <20080909152952.GA21207@us.ibm.com> <DE845309-1684-472A-8269-78AB3A2823A9@oracle.com> <m1fxo9mba5.fsf@frodo.ebiederm.org> <48C791F9.8090606@fr.ibm.com> <76bd70e30809100812r4a7fa71crfc7196350e3ed1cf@mail.gmail.com> <m1ej3rixbx.fsf@frodo.ebiederm.org>
In-Reply-To: <m1ej3rixbx.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The conservative play is to always force use of the initial namespace
> and to deny creation of mounts that would use different namespaces.  In part
> because the initial version of the namespace always exists.  Which means
> as relates to Cedrics initial patch we would still need to know which
> mounts should cause us to use a different uts namespace so we can deny
> them.

I will send the initial patch which forces use of the initial namespace because
it does fix a real oops. 

Then, I should be able to find some time to work on improving the uts namespace
checks when NFS mounts are done.

Thanks !

C.
