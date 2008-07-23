Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbYGWWF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbYGWWF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 18:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbYGWWFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 18:05:48 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:36308 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbYGWWFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 18:05:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=g1xj8ZWWN3kOy4PaHt9ba2/UrFdt3TNyXLOh9eo6DyNVF7boMc0SWC/xHsc4LInHDC
         GugIcUr+jtX5iLDLSUcAe7pv4se5iDKDUE7LQ2Se9LLJspVbekbmGI742/L0qxxU/2un
         ZBFynzQX2y3sMqjsoMHqEBADQduGBgQRMZBpo=
Message-ID: <19f34abd0807231505w1a25c2bak329a622f3a287e97@mail.gmail.com>
Date: Thu, 24 Jul 2008 00:05:45 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: recent -git: BUG in free_thread_xstate
Cc: "Suresh Siddha" <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <b647ffbd0807231501va30f6d4kee49d1daa30227fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807231307y191c0ad7tfab4cda57ee88eb@mail.gmail.com>
	 <20080723203109.GH14380@linux-os.sc.intel.com>
	 <19f34abd0807231352j1ba1414am84ee9683df9b5657@mail.gmail.com>
	 <b647ffbd0807231422w546e59e9p8362ee798b169a25@mail.gmail.com>
	 <b647ffbd0807231435h73740808p76143d3d4457b597@mail.gmail.com>
	 <19f34abd0807231445h79fac5cbwecd0563b74bc18ad@mail.gmail.com>
	 <b647ffbd0807231501va30f6d4kee49d1daa30227fc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 12:01 AM, Dmitry Adamushko
<dmitry.adamushko@gmail.com> wrote:
>> BUG: unable to handle kernel paging request at c0804358
>> IP: [<c057e38d>] schedule+0x1ed/0x850

[...]

> So I guess, 'cpu' value is slightly, well, out of reality. Check the
> address of "runqueues" in your kernel image...
> I guess, it should be quite close to the "fault" address... then we
> can even calculate 'cpu' :-)

Yup, that's right.

$ nm vmlinux | grep runqueues
c0803f00 d per_cpu__runqueues


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
