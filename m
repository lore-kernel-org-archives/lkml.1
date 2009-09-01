Return-Path: <linux-kernel-owner+w=401wt.eu-S1753063AbZIASo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbZIASo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 14:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbZIASo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 14:44:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54143 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbZIASoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 14:44:54 -0400
Date: Tue, 1 Sep 2009 14:44:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_pages
Message-ID: <20090901184455.GA27294@infradead.org>
References: <1251803946-9243-1-git-send-email-jens.axboe@oracle.com> <1251803946-9243-9-git-send-email-jens.axboe@oracle.com> <1251830335.8502.17.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251830335.8502.17.camel@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 08:38:55PM +0200, Peter Zijlstra wrote:
> Do we really need a tunable for this?

It will make increasing it in the field a lot easier.  And having deal
with really large systems I have the fear that there are I/O topologies
outhere for which every "reasonable" value is too low.

> I guess we need a limit to avoid it writing out everything, but can't we
> have something automagic?

Some automatic adjustment would be nice.  But finding the right auto
tuning will be an interesting exercise.

