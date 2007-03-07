Return-Path: <linux-kernel-owner+w=401wt.eu-S1751724AbXCGLks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbXCGLks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 06:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbXCGLkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 06:40:47 -0500
Received: from lazybastard.de ([212.112.238.170]:55714 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbXCGLkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 06:40:46 -0500
Date: Wed, 7 Mar 2007 12:30:16 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Jan Kara <jack@suse.cz>
Cc: Eric Sandeen <sandeen@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Christoph Hellwig <hch@infradead.org>, Mingming Cao <cmm@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, nscott@aconex.com,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, suparna@in.ibm.com, alex@clusterfs.com,
       suzuki@in.ibm.com
Subject: Re: [RFC] Heads up on sys_fallocate()
Message-ID: <20070307113016.GC15583@lazybastard.org>
References: <1172788855.26078.294.camel@edge> <20070301145256.3e999932.akpm@linux-foundation.org> <45E86CBA.3070905@us.ibm.com> <20070305122742.GA11486@atrey.karlin.mff.cuni.cz> <45EC7773.7020603@us.ibm.com> <20070306072850.GA23081@infradead.org> <45ED7C59.4050508@redhat.com> <20070306145009.GB3661@duck.suse.cz> <45EDB19A.6030103@redhat.com> <20070307085135.GB29373@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070307085135.GB29373@duck.suse.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 March 2007 09:51:35 +0100, Jan Kara wrote:
>
>   I'll probably first write some userspace fs-reorganizer to find out how
> much these changes in layout are able to give you in performance (i.e.
> whether it's worth the effort of more complicated kernel online
> defragmenter).

Have tried profiling the read accesses and prereading them
asynchronously on startup?  That appears to have improved E17 a lot.
See http://lca2007.linux.org.au/talk/101 (and watch the video).

Jörn

-- 
The competent programmer is fully aware of the strictly limited size of
his own skull; therefore he approaches the programming task in full
humility, and among other things he avoids clever tricks like the plague.
-- Edsger W. Dijkstra
