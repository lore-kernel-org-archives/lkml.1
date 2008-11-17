Return-Path: <linux-kernel-owner+w=401wt.eu-S1752648AbYKQTKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbYKQTKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:10:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYKQTJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:09:57 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45517 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbYKQTJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:09:56 -0500
Subject: Re: [PATCH 2/4] integrity: Linux Integrity Module(LIM)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20081117160515.GA25459@infradead.org>
References: <cover.1226547084.git.zohar@linux.vnet.ibm.com>
	 <9395c0a4110469d19100084664900789c34ebd42.1226547084.git.zohar@linux.vnet.ibm.com>
	 <20081117160515.GA25459@infradead.org>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 14:09:40 -0500
Message-Id: <1226948980.2927.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-17 at 11:05 -0500, Christoph Hellwig wrote: 
> On Wed, Nov 12, 2008 at 10:47:12PM -0500, Mimi Zohar wrote:
> > This version resolves the merge issues resulting from the removal
> > of the nameidata parameter to inode_permission(), by moving the
> > integrity_inode_permission() call from inode_permission() to
> > may_open(), and renaming the hook to integrity_nameidata_check().
> 
> Still neither a good parameter nor a good name.  If you look at fsdevel
> you'll see that a patch for the next merged window is already out and
> in Al's to be applied queue that removes the nameidata there.  A
> strcut path and maybe the MAY_ lookup flags should be enough for you,
> and a integrity_path_check also sounds like it really does what you
> want.

Ok. So, instead of integrity_nameidata_check(nd, flags), call it
integrity_path_check(path, flags). 

Perhaps I'm looking at the wrong vfs tree, but I don't see the changes.
Where is fsdevel? 

> Also please merge the last radix tree patch into this one so tat it's
> possible to review the code that actually goes in instead of replacing
> a large part of it in a follow-up patch.

np

Mimi

