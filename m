Return-Path: <linux-kernel-owner+w=401wt.eu-S1758063AbXKCSW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbXKCSW1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 14:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757551AbXKCSWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 14:22:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48722 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756737AbXKCSWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 14:22:06 -0400
Date: Sat, 3 Nov 2007 11:22:03 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Greg KH <greg@kroah.com>, Latchesar Ionkov <lucho@ionkov.net>,
       v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/10] 9p: sysfs support for in-kenel servers
In-Reply-To: <1194085985.27652.409.camel@twins>
Message-ID: <Pine.LNX.4.64.0711031121250.5395@schroedinger.engr.sgi.com>
References: <20071102170527.GH16063@ionkov.net>  <20071103034812.GC16234@kroah.com>
 <1194085985.27652.409.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2007, Peter Zijlstra wrote:

> On Fri, 2007-11-02 at 20:48 -0700, Greg KH wrote:
> 
> > Also, a sysfs file that causes an action to happen just by reading the
> > file is not a safe thing to have.  Lots of scripts have been known to
> > just walk the whole sysfs tree and open and read everything they can for
> > no real good reason.  So you should seriously reconsider this kind of
> > interaction.
> 
> Christoph, doesn't SLUB do exactly that?

SLUB gathers statistics and summaries and displays them on read.

