Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbZCPKN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbZCPKN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 06:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbZCPKNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 06:13:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56909 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbZCPKNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 06:13:45 -0400
Date: Mon, 16 Mar 2009 06:13:43 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, npiggin@suse.de
Subject: Re: [PATCH 3/7] writeback: get rid of pdflush_operation() in
	emergency sync and remount
Message-ID: <20090316101343.GA21118@infradead.org>
References: <1236868428-20408-1-git-send-email-jens.axboe@oracle.com> <1236868428-20408-4-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236868428-20408-4-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 03:33:44PM +0100, Jens Axboe wrote:
> Opencode a cheasy approach with kevent. The idea here is that we'll
> add some generic delayed work infrastructure, which probably wont be
> based on pdflush (or maybe it will, in which case we can just add it
> back).

Good idea.  Care to submit this early outside of the series?

> 
