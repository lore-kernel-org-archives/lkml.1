Return-Path: <linux-kernel-owner+w=401wt.eu-S1751742AbXJVKO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbXJVKO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 06:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbXJVKOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 06:14:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46223 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbXJVKOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 06:14:48 -0400
Date: Mon, 22 Oct 2007 11:14:43 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Blunck <jblunck@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, Christoph Hellwig <hch@lst.de>,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] Rename {__}d_path() to {__}print_path() and fix comments
Message-ID: <20071022101443.GB20690@infradead.org>
References: <20071022065352.GA6489@in.ibm.com> <20071022070419.GN6489@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022070419.GN6489@in.ibm.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 12:34:19PM +0530, Bharata B Rao wrote:
> Changes the name of d_path() and __d_path() to print_path() and __print_path()
> respectively and fixes the kerneldoc comments for print_path().

I don't think we want to put in this rename until d_path is changed to
actually take a struct path * describing the path to be printed.

