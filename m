Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbXJDGwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbXJDGwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 02:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbXJDGwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 02:52:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39167 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbXJDGwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 02:52:09 -0400
Date: Thu, 4 Oct 2007 07:52:04 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Mingming Cao <cmm@us.ibm.com>, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] jbd/jbd2: JBD memory allocation cleanups
Message-ID: <20071004065204.GA21481@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>,
	Christoph Lameter <clameter@sgi.com>
References: <1191477059-5357-1-git-send-email-tytso@mit.edu> <1191477059-5357-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191477059-5357-2-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 01:50:36AM -0400, Theodore Ts'o wrote:
> From: Mingming Cao <cmm@us.ibm.com>
> 
> JBD: Replace slab allocations with page cache allocations

It's page allocations, not page cache allocations.

> Also this patch cleans up jbd_kmalloc and replace it with kmalloc directly

That sounds like it should be a different patch..

