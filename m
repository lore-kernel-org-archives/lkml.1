Return-Path: <linux-kernel-owner+w=401wt.eu-S1752965AbXDUVJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbXDUVJH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 17:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbXDUVJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 17:09:07 -0400
Received: from ns2.suse.de ([195.135.220.15]:45388 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbXDUVJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 17:09:05 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, serue@us.ibm.com,
       viro@ftp.linux.org.uk, linuxram@us.ibm.com, ebiederm@xmission.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [patch 7/8] allow unprivileged mounts
References: <20070420102532.385211890@szeredi.hu>
	<20070420102652.075606533@szeredi.hu>
	<20070421005513.e230aa88.akpm@linux-foundation.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 22 Apr 2007 00:06:51 +0200
In-Reply-To: <20070421005513.e230aa88.akpm@linux-foundation.org>
Message-ID: <p73d51x4c1w.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 20 Apr 2007 12:25:39 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > Define a new fs flag FS_SAFE, which denotes, that unprivileged
> > mounting of this filesystem may not constitute a security problem.
> > 
> > Since most filesystems haven't been designed with unprivileged
> > mounting in mind, a thorough audit is needed before setting this flag.
> 
> Practically speaking, is there any realistic likelihood that any filesystem
> apart from FUSE will ever use this?

If it worked for mount --bind for any fs I could see uses of this.  I haven't thought
through the security implications though, so it might not work.

-Andi
