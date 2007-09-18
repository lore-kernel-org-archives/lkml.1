Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbXIRBlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbXIRBlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 21:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbXIRBlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 21:41:12 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:12063 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbXIRBlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 21:41:11 -0400
Date: Mon, 17 Sep 2007 18:38:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: pete@bluelane.com, Jason Wessel <jason.wessel@windriver.com>,
       Matt Mackall <mpm@selenic.com>, Amit Kale <amitkale@linsyssoft.com>,
       Dave Anderson <anderson@redhat.com>, kdb@oss.sgi.com, jlan@sgi.com,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: My position on general ``RAS'' tool support infrastructure
Message-Id: <20070917183853.42f29393.randy.dunlap@oracle.com>
In-Reply-To: <m1abrq7lbt.fsf@ebiederm.dsl.xmission.com>
References: <46E8B06D.9080006@bluelane.com>
	<m1abrq7lbt.fsf@ebiederm.dsl.xmission.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007 07:21:10 -0600 Eric W. Biederman wrote:

> Pete/Piet Delaney <pete@bluelane.com> writes:
> 
> > Jason, Eric:
> >
> > Did you read Keith Owens suggestion on RAS tools from:


Yes.  and I re-read it.

There are several things in Keith's email that make sense:

a.  all RAS tools should use a common interface
b.  it's not the kernel's job to decide which RAS tool runs first


Eric makes some good points too.  I'm mostly similar to Eric:
paranoid about trusting software/hardware after a panic (or oops).

So if someone wants to use multiple RAS tools on a panic event,
enabling an admin to set priorities is OK with me, but I'll only
trust the first one that is used, and even that one may have
problems.  IOW, I don't see a big need to support multiple RAS
tools at one time.  (speaking for myself)


> So if someone who is suggesting an implementation can absorb 
> and understand the requirements of the different groups and come
> up with solutions that meet the requirements of the different projects
> I think progress can be made.  That as far as I know takes talent.

Ack that.

---
~Randy
