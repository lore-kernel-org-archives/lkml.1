Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbZKTRJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbZKTRJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:09:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZKTRJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:09:07 -0500
Received: from mail2.shareable.org ([80.68.89.115]:50888 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZKTRJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:09:06 -0500
Date: Fri, 20 Nov 2009 17:09:06 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, jkacur@redhat.com,
       Arnd Bergmann <arnd@arndb.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Willem Riede <osst@riede.org>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>
Subject: Re: [PATCH 02/15] osst: Use noop_llseek() instead of default_llseek()
Message-ID: <20091120170906.GG20634@shareable.org>
References: <1258735245-25826-1-git-send-email-jblunck@suse.de> <1258735245-25826-3-git-send-email-jblunck@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258735245-25826-3-git-send-email-jblunck@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Blunck wrote:
> __os_scsi_tape_open() suggests that llseek() doesn't work:
> "We really want to do nonseekable_open(inode, filp); here, but some
>  versions of tar incorrectly call lseek on tapes and bail out if that
>  fails.  So we disallow pread() and pwrite(), but permit lseeks."
> 
> Instead of using the fallback default_llseek() the driver should use
> noop_llseek() which leaves the file->f_pos untouched but succeeds.

st.c has the same comment, but I didn't see a patch for st.c in the series.

-- Jamie
