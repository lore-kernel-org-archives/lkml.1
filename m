Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbYLYUdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbYLYUdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 15:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYLYUdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 15:33:09 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47017 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbYLYUdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 15:33:08 -0500
Date: Thu, 25 Dec 2008 20:33:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "C. Scott Ananian" <cscott@laptop.org>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH -v4 00/14] fsnotify, dnotify, and inotify
Message-ID: <20081225203302.GS28946@ZenIV.linux.org.uk>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com> <c6d9bea0812181536p2a3aaeacmbd6af0474279b7b@mail.gmail.com> <1229916126.29604.47.camel@localhost.localdomain> <c6d9bea0812221159h30b0501dm8f48d93e0cb53bfa@mail.gmail.com> <20081222210410.GL28946@ZenIV.linux.org.uk> <c6d9bea0812221508n75f03ebdsff5bcbabe56eae56@mail.gmail.com> <20081222232125.GA25334@infradead.org> <c6d9bea0812251017u6a271fc0j5d26b8bbe3407877@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6d9bea0812251017u6a271fc0j5d26b8bbe3407877@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 01:17:28PM -0500, C. Scott Ananian wrote:
> getcwd doesn't actually hold a file descriptor to the working
> directory.  If you reread my message, you'll find that I was explicit
> about where the information was stored.

Indeed - explicit, persistent and wrong.  For current directory of a process
we store vfsmount and dentry.  And use those in getcwd() rather than playing
hopeless games with inodes.
