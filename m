Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbZKTRF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbZKTRF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbZKTRF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:05:56 -0500
Received: from mail2.shareable.org ([80.68.89.115]:50876 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbZKTRF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:05:56 -0500
Date: Fri, 20 Nov 2009 17:05:47 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, jkacur@redhat.com,
       Arnd Bergmann <arnd@arndb.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 01/15] Introduce noop_llseek()
Message-ID: <20091120170547.GF20634@shareable.org>
References: <1258735245-25826-1-git-send-email-jblunck@suse.de> <1258735245-25826-2-git-send-email-jblunck@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258735245-25826-2-git-send-email-jblunck@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Blunck wrote:
> The noop_llseek() is a llseek() operation that filesystems can use that
> don't want to support seeking (leave the file->f_pos untouched) but still
> want to let the syscall itself to succeed.

This is weird behaviour: if you want to allow llseek() to succeed but
don't really support seeking, why does the device even care about the
value of file->f_pos?

-- Jamie
