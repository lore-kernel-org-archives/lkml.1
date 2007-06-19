Return-Path: <linux-kernel-owner+w=401wt.eu-S1759070AbXFSHCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070AbXFSHCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 03:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755952AbXFSHC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 03:02:29 -0400
Received: from THUNK.ORG ([69.25.196.29]:47890 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729AbXFSHC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 03:02:28 -0400
Date: Tue, 19 Jun 2007 03:01:21 -0400
From: Theodore Tso <tytso@mit.edu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, alan <alan@clueserver.org>,
       Bodo Eggert <7eggert@gmx.de>, Jack Stone <jack@hawkeye.stone.uk.eu.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070619070121.GA9177@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	"H. Peter Anvin" <hpa@zytor.com>, alan <alan@clueserver.org>,
	Bodo Eggert <7eggert@gmx.de>,
	Jack Stone <jack@hawkeye.stone.uk.eu.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org, viro@zeniv.linux.org.uk
References: <8wsW4-3UY-3@gated-at.bofh.it> <8wJal-3KA-1@gated-at.bofh.it> <8xm22-4Ql-1@gated-at.bofh.it> <8xq5G-32l-7@gated-at.bofh.it> <8xs7w-69W-21@gated-at.bofh.it> <E1I0OFQ-0001B9-7Z@be1.lrz> <Pine.LNX.4.64.0706181406250.25913@blackbox.fnordora.org> <4676F9A2.6010007@zytor.com> <20070618221021.GB2062@thunk.org> <20070618222656.GB25089@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070618222656.GB25089@lazybastard.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 12:26:57AM +0200, Jörn Engel wrote:
> The main difference appears to be the potential size.  Both extended
> attributes and forks allow for extra data that I neither want or need.
> But once the extra space is large enough to hide a rootkit in, it
> becomes a security problem instead of just something pointless.

The other difference is that you can't execute an extended attribute.

You can store kvm/qemu, a complete virtualization enviroment, shared
libraries, and other executables all inside a forks inside a file, and
then execute programs/rootkit out of said file fork(s).

As I mentioned in my LCA presentation, one system administrator
refused to upgrade beyond Solaris 8 because he thought forks were good
for nothing but letting system crackers hide rootkits that wouldn't be
detected by programs like tripwire.  The question then is why in the
world would we want to replicate Sun's mistakes?

						- Ted
