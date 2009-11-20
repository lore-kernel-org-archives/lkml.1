Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbZKTRBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbZKTRBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZKTRBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:01:17 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37163 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754140AbZKTRBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:01:16 -0500
Date: Fri, 20 Nov 2009 17:02:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, jkacur@redhat.com,
       Arnd Bergmann <arnd@arndb.de>,
       =?ISO-8859-14?B?RnLp?= =?ISO-8859-14?B?ZOlyaWM=?= Weisbecker 
	<fweisbec@gmail.com>,
       Jamie Lokier <jamie@shareable.org>, Jan Blunck <jblunck@suse.de>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 15/15] BKL: Update documentation on
 =?ISO-8859-14?B?bGxzZWVrKAgp?=
Message-ID: <20091120170225.7ea2b37e@lxorguk.ukuu.org.uk>
In-Reply-To: <1258735245-25826-16-git-send-email-jblunck@suse.de>
References: <1258735245-25826-1-git-send-email-jblunck@suse.de>
	<1258735245-25826-16-git-send-email-jblunck@suse.de>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 17:40:45 +0100
Jan Blunck <jblunck@suse.de> wrote:

> The inode's i_size is not protected by the big kernel lock. Therefore it
> does not make sense to recommend taking the BKL in filesystems llseek
> operations. Instead it should use the inode's mutex or use just use
> i_size_read() instead. Add a note that this is not protecting file->f_pos.

Looks good to me reading through it.

Alan
