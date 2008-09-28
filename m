Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbYI1CR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbYI1CR4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 22:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbYI1CRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 22:17:48 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:57962 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751684AbYI1CRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 22:17:48 -0400
Date: Sat, 27 Sep 2008 22:17:46 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ivan Zorin <ivan.a.zorin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [question] "copy-on-write" in ext4
Message-ID: <20080928021746.GB5025@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Ivan Zorin <ivan.a.zorin@gmail.com>, linux-kernel@vger.kernel.org
References: <48DEBCE9.3000002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DEBCE9.3000002@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2008 at 03:08:25AM +0400, Ivan Zorin wrote:
> Hello, everybody. I have a question to ext4 filesystem developers. Could  
> you tell me please, have you planned to implement (no matter, how soon)  
> in ext4 some "copy-on-write" feature? If you have, then how it will be  
> looks like (and how soon :-) ?
> If you haven't, then did you think about ability to implement such  
> feature and how it could be?

What do you mean by "copy on write", precisely?  Do you mean at the
file level, directory level, or the filesystem level? 

We don't have any plans to implement "copy on write" in ext4, although
you can create a copy-on-write snapshot at the block device level
using LVM/devicemapper.  For many things (database backups, etc.) this
is quite suitable.

So why don't you tell us what you are trying to do, and we can suggest
to you ways that you might be able to do it.

							- Ted
