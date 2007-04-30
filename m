Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbXD3KuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbXD3KuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbXD3KuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:50:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35384 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbXD3KuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:50:13 -0400
Date: Mon, 30 Apr 2007 11:50:09 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <ak@suse.de>, mingo@elte.hu
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [39/40] i386: Export paravirt_ops for non GPL modules too
Message-ID: <20070430105009.GB14944@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andi Kleen <ak@suse.de>, mingo@elte.hu, patches@x86-64.org,
	linux-kernel@vger.kernel.org
References: <200704301227.598020000@suse.de> <20070430102814.7E56E151D2@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430102814.7E56E151D2@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 12:28:14PM +0200, Andi Kleen wrote:
> 
> Otherwise non GPL modules cannot even do basic operations
> like disabling interrupts anymore, which would be excessive.
> 
> Longer term should split the single structure up into
> internal and external symbols and not export the internal
> ones at all.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>

Ingo was dead-set against this and I kinda agree. 
