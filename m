Return-Path: <linux-kernel-owner+w=401wt.eu-S1755003AbYAPQjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbYAPQjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 11:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYAPQjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 11:39:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53761 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbYAPQja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 11:39:30 -0500
Date: Wed, 16 Jan 2008 16:38:35 +0000
From: Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>
Cc: Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Theodore Tso <tytso@mit.edu>, Al Boldi <a1426z@gawab.com>,
       Valerie Henson <val.henson@gmail.com>, Rik van Riel <riel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental
	fsck)
Message-ID: <20080116163834.GA22382@infradead.org>
References: <200801090022.55589.a1426z@gawab.com> <200801090740.12989.a1426z@gawab.com> <70b6f0bf0801082345vf57951ey642e35c3d6e5194f@mail.gmail.com> <200801091452.14890.a1426z@gawab.com> <20080112145140.GB6751@mit.edu> <20080113171916.GB4132@ucw.cz> <20080113174125.5f39ac64@lxorguk.ukuu.org.uk> <20080115201653.GA5639@elf.ucw.cz> <20080115214325.GN155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115214325.GN155407@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 08:43:25AM +1100, David Chinner wrote:
> ext3 is not the only filesystem that will have trouble due to
> volatile write caches. We see problems often enough with XFS
> due to volatile write caches that it's in our FAQ:

In fact it will hit every filesystem.  A write-back cache that can't
be forced to write back bythe filesystem will cause corruption on
uncontained power loss, period.

