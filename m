Return-Path: <linux-kernel-owner+w=401wt.eu-S1760759AbZB0VVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760759AbZB0VVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759052AbZB0VU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:20:57 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:48084 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080AbZB0VU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:20:56 -0500
Subject: Re: [RFC][PATCH 3/8] create fs flags to mark c/r supported fs's
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>, hch@infradead.org
In-Reply-To: <20090227211620.GA3326@x200.localdomain>
References: <20090227203425.F3B51176@kernel>
	 <20090227203428.556600DA@kernel>  <20090227211620.GA3326@x200.localdomain>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 13:20:50 -0800
Message-Id: <1235769650.26788.388.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-28 at 00:16 +0300, Alexey Dobriyan wrote:
> On Fri, Feb 27, 2009 at 12:34:28PM -0800, Dave Hansen wrote:
> > +#define FS_CHECKPOINTABLE 8
> 
> This will ban all sockets, for instance, until all of them are
> C/R-ready. And every new socket type must be made C/R-ready from
> the very beginning, or risk major C/R breakage.

Yes, it is very important to have fine-grained control over what is
checkpointable and not.  We can't simply say "all sockets are OK" all at
once.  I meant this as a high-level things so that I didn't have to go
chase down the several f_ops for each in and every filesystem that is
supported.

Did you look farther down in the patches to see how this can be
overridden with an f_op?

-- Dave

