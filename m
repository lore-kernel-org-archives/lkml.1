Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbXCZUuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbXCZUuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 16:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbXCZUuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 16:50:25 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43040 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbXCZUuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 16:50:24 -0400
Subject: Re: [Patch 5/7] integrity: mtime patch for mmap files
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com,
       staubach@redhat.com
In-Reply-To: <20070325002656.0a5ceff0.akpm@linux-foundation.org>
References: <1174666198.11149.5.camel@localhost.localdomain>
	 <20070325002656.0a5ceff0.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 16:49:07 -0400
Message-Id: <1174942147.5713.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-25 at 00:26 -0800, Andrew Morton wrote: 
> On Fri, 23 Mar 2007 12:09:58 -0400 Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > mmaped files are hashed and hmac'ed properly by EVM after being modified
> > when the file's mtime is updated correctly.  Peter Staubach's 'memory
> > mapped files not updating timestamps v2' patch properly updates the
> > mmapped file's mtime.  In those cases when an application does not
> > first msync the file before calling munmap, the mtime is eventually
> > updated, but not before file_close is called.  This patch forces the
> > mtime for mmaped files to be updated in a timely manner.
> 
> I don't think we've ever had that patch in -mm?

We are basing the EVM code on Peter's '[PATCH] memory mapped files not 
updating timestamps v2' patch http://lkml.org/lkml/2007/2/20/255 on the
assumption that it would be accepted.  I guess that has not yet happened.

Mimi Zohar

