Return-Path: <linux-kernel-owner+w=401wt.eu-S932095AbZKKXKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbZKKXKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 18:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759296AbZKKXKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 18:10:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759611AbZKKXKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 18:10:35 -0500
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>, Wu Fengguang <fengguang.wu@intel.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, mingo@elte.hu,
       Frederic Weisbecker <fweisbec@gmail.com>, auke-jan.h.kok@intel.com
Subject: Re: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
References: <20091025225342.007138f5@infradead.org>
	<20091111020108.GA11423@localhost>
	<20091110223456.01ef355f@infradead.org> <4AFA6AEF.5060306@garzik.org>
	<20091111081905.270a4e55@infradead.org>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Wed, 11 Nov 2009 18:10:15 -0500
In-Reply-To: <20091111081905.270a4e55@infradead.org> (Arjan van de Ven's message of "Wed, 11 Nov 2009 08:19:05 -0800")
Message-ID: <y0m3a4kpsiw.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> [...]  ok let me rephrase that. What would a user DO with this inode
> number information, given that the filename is already passed on;
> what additional useful, not-infinitely-hard-to-get piece of
> information [...]

Perhaps "infinitely hard" is the wrong criterion, but passing inode
numbers lets a tracepoint client track changes to the same file, even
though the file may be renamed/unlinked over time.

- FChE
