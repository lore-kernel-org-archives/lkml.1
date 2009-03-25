Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbZCYTBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbZCYTBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 15:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbZCYTBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 15:01:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49693 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbZCYTBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:01:39 -0400
Date: Wed, 25 Mar 2009 15:01:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Bill Nottingham <notting@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Add a 'wait-scan' command to /proc/scsi/scsi.
Message-ID: <20090325190137.GA8509@infradead.org>
References: <1238007647-25752-1-git-send-email-notting@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238007647-25752-1-git-send-email-notting@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 03:00:46PM -0400, Bill Nottingham wrote:
> scsi_wait_scan.ko is a bad interface for a variety of reasons:
> - once you load it, it stays in memory doing nothing
> - if you need to call it again, you first need to check for the module
>   and unload it first
> - waiting for scsi scans shouldn't require module loading privleges in
>   any case
> 
> This creates a simpler interface that doesn't require as much
> scaffolding in userspace.

/proc/scsi/scsi is deprecated, plese don't add more features to it.

