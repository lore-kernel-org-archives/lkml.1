Return-Path: <linux-kernel-owner+w=401wt.eu-S1760486AbYALVK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760486AbYALVK1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 16:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756974AbYALVKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 16:10:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54852 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420AbYALVKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 16:10:17 -0500
Date: Sat, 12 Jan 2008 21:10:15 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Tino Keitel <tino.keitel@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Could not set non-blocking flag with 2.6.24-rc5
Message-ID: <20080112211015.GA4991@infradead.org>
References: <20071213201601.GA5831@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213201601.GA5831@dose.home.local>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 09:16:01PM +0100, Tino Keitel wrote:
> Hi folks,
> 
> I often build Debian packages inside a chroot. Today I discovered a
> failure during an "aptitude update", which is a command to download new
> package lists for the package management. In strace, the lines around
> the failure look like this:

Are you using XFS?  This looks a lot like the bug I introduced where
i_rdev gets a wrong value assigned after mknod.   In that case please
try -rc7 as it has a fix for that particular problem.

