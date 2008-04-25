Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbYDYHBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbYDYHBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 03:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbYDYHBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 03:01:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38735 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbYDYHBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 03:01:39 -0400
Date: Fri, 25 Apr 2008 03:01:36 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Soeren Sandmann <sandmann@daimi.au.dk>, linux-kernel@vger.kernel.org
Subject: Re: stat benchmark
Message-ID: <20080425070136.GA13138@infradead.org>
References: <ye8wsmnezq9.fsf@camel05.daimi.au.dk> <alpine.LNX.1.10.0804242329060.11644@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0804242329060.11644@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 11:44:04PM +0200, Jan Engelhardt wrote:
> XFS for example already has bulkstat, but it is not really
> exported to userspace :-/

It is avaiable through an ugly ioctl.  Doesn't really help in this
use-case because bulkstat iterates over all inodes of a given filesystem
and not inodes of a directory.

