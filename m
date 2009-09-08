Return-Path: <linux-kernel-owner+w=401wt.eu-S1751211AbZIHOkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211AbZIHOkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 10:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbZIHOkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 10:40:21 -0400
Received: from mail2.shareable.org ([80.68.89.115]:51125 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbZIHOkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 10:40:20 -0400
Date: Tue, 8 Sep 2009 15:40:12 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: Re: [PATCH 3/8] Simplify exec_permission_lite() further
Message-ID: <20090908144012.GB5579@shareable.org>
References: <alpine.LFD.2.01.0909071337510.3419@localhost.localdomain> <alpine.LFD.2.01.0909071401210.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402220.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402510.3419@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909071402510.3419@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> This function is only called for path components that are already known
> to be directories (they have a '->lookup' method).  So don't bother
> doing that whole S_ISDIR() testing,

A few years ago you briefly discussed diddling the VFS to accept
objects which are both files and directories.  That is, have
->lookup() and also can be read as regular files.

I don't know if your thinking has changed, and I don't particularly
care, only thought I'd remind in case it's something you'd like to
support at some point.

-- Jamie
