Return-Path: <linux-kernel-owner+w=401wt.eu-S1752197Ab0AHNIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab0AHNIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 08:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715Ab0AHNIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 08:08:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60346 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab0AHNIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 08:08:35 -0500
Date: Fri, 8 Jan 2010 08:08:28 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Quentin Barnes <qbarnes+nfs@yahoo-inc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH v2] readahead: introduce O_RANDOM_READ for
	POSIX_FADV_RANDOM
Message-ID: <20100108130828.GA30480@infradead.org>
References: <20091225000717.GA26949@yahoo-inc.com> <87aax18xms.fsf@basil.nowhere.org> <20091230051540.GA16308@localhost> <20091230052402.GB26364@localhost> <873a2s8hmp.fsf@basil.nowhere.org> <20091231043116.GA19397@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091231043116.GA19397@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just thinking about this again, why don't you put the flag into
file->f_mode and the FMODE_* namespace given that we don't want it to be
settable from open?

