Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbYAIICb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbYAIICb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 03:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYAIICX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 03:02:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49918 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbYAIICW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 03:02:22 -0500
Date: Wed, 9 Jan 2008 08:02:19 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Kevin Winchester <kjwinchester@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       apw@shadowen.org
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Message-ID: <20080109080219.GD32560@infradead.org>
References: <20080108164015.GC31504@one.firstfloor.org> <200801090140.58864.arnd@arndb.de> <20080109004748.GI2117@one.firstfloor.org> <200801090219.46876.arnd@arndb.de> <478423EC.5020000@gmail.com> <20080109014152.GJ2117@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109014152.GJ2117@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 02:41:52AM +0100, Andi Kleen wrote:
> There are a few like scsi_host_template that don't have a unlocked_ioctl yet,
> but that is just something that needs to be fixed.

There's few enough scsi LLDDs with an ioctl method that ->ioctl should
be switched over in a single patch.  No need to add another method.
