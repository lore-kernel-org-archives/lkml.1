Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbZGNQiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbZGNQiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZGNQiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:38:24 -0400
Received: from smtp.nokia.com ([192.100.122.233]:62524 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbZGNQiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:38:23 -0400
Message-ID: <4A5CB414.5000001@nokia.com>
Date: Tue, 14 Jul 2009 19:36:36 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       "torvalds@osdl.org" <torvalds@osdl.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] AFS: Fix compilation warning
References: <1247561220.2473.0.camel@ht.satnam> <20090709094430.23882.46013.stgit@warthog.procyon.org.uk> <5554.1247588246@redhat.com>
In-Reply-To: <5554.1247588246@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 14 Jul 2009 16:36:41.0884 (UTC) FILETIME=[447E15C0:01CA04A1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

David Howells wrote:
> Can you try Jaswinder's patch?  I don't see the warning even without your
> patch, so I can't test it.

Linus has already applied my patch which you sent him:

commit dd0d9a46f573b086a67522f819566427dba9c4c7
Author: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date:   Thu Jul 9 10:44:30 2009 +0100

    AFS: Fix compilation warning

But this patch applies to both current linux-2.6.git and to
pre-"AFS: Fix compilation warning" tree.

I've compile-tested the latter and yes, this patch fixes
the warning.

FWIW, if you want to apply this patch, then you probably
should first revert my patch, or make this patch undo my
"unitinialized_var" changes. And probably this stuff is
anyway not 2.6.31 material, because the warning is fixed
anyway :-) Anyway, not my area :-)

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
