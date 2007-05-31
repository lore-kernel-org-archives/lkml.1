Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbXEaGN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbXEaGN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 02:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757235AbXEaGNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 02:13:50 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:24807 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164AbXEaGNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 02:13:49 -0400
Date: Wed, 30 May 2007 23:12:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, David Chinner <dgc@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/fork.c:385
Message-Id: <20070530231223.bc75f7fb.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0705301657530.3832@schroedinger.engr.sgi.com>
References: <617E1C2C70743745A92448908E030B2A01929C15@scsmsx411.amr.corp.intel.com>
	<Pine.LNX.4.64.0705301630360.3568@schroedinger.engr.sgi.com>
	<20070530163413.87ecfe18.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0705301652100.3731@schroedinger.engr.sgi.com>
	<465E0F03.6000103@oracle.com>
	<Pine.LNX.4.64.0705301657530.3832@schroedinger.engr.sgi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 17:09:56 -0700 (PDT) Christoph Lameter wrote:

> On Wed, 30 May 2007, Randy Dunlap wrote:
> 
> > OK.  I would write the file to disk and view it with an editor.
> > Then at each occurrence of /exit.text/, see if it's inside an __init
> > function...
> 
> Ahh okay. cscope will do that too.... But all have __exit.

I did a cross-build, but I'm not having any luck finding the problem
either.  FWIW, mine shows up as:

  LD      .tmp_vmlinux1
local symbol 0: discarded in section `.exit.text' from drivers/built-in.o
make[1]: [.tmp_vmlinux1] Error 1 (ignored)
  KSYM    .tmp_kallsyms1.S

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
