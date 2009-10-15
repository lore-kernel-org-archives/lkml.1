Return-Path: <linux-kernel-owner+w=401wt.eu-S1762219AbZJOAJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762219AbZJOAJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 20:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762208AbZJOAJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 20:09:24 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:59558 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762205AbZJOAJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 20:09:22 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ray Lee <ray-lk@madrabbit.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Staubach <staubach@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
       xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: mmap vs mtime in 2.6.26 and up
References: <20090518114305.GA6303@infradead.org>
	<87vdj742dt.fsf@tac.ki.iif.hu> <20090926131043.GA25204@infradead.org>
Date: Thu, 15 Oct 2009 02:08:22 +0200
In-Reply-To: <20090926131043.GA25204@infradead.org> (Christoph Hellwig's
	message of "Sat, 26 Sep 2009 09:10:43 -0400")
Message-ID: <87oco94iyx.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Fri, Sep 25, 2009 at 02:47:42PM +0200, Ferenc Wagner wrote:
>
>> I added some fresh test results to
>> http://bugzilla.kernel.org/show_bug.cgi?id=2645.  In short, under
>> 2.6.30-rc8 the test program reports full failure on XFS and RAMFS,
>> full success on EXT3, VFAT and ReiserFS, and mixed results on TMPFS:
>
> There's a patch queued up for inclusion in 2.6.32 to work around this
> issue in XFS.  The lack of a proper callout from the VFS still makes
> this a much less than ideal solution.

Great, anyway!  Somehow I managed to gloss over this mail until now,
but happened to test 2.6.32-rc4 and found the issue fixed.  At least
for XFS, as my latest addition to the bug report details it.  Thank
you very much for taking care of this issue!
-- 
Regards,
Feri.
