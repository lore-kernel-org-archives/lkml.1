Return-Path: <linux-kernel-owner+w=401wt.eu-S1757086AbYFCCSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbYFCCSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 22:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYFCCSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 22:18:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50683 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbYFCCSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 22:18:36 -0400
Date: Mon, 2 Jun 2008 19:18:32 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Brice Goglin <brice@myri.com>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>
Subject: Re: howto use ioremap_wc?
Message-ID: <20080602191832.0858eff9@infradead.org>
In-Reply-To: <48441F73.5040005@myri.com>
References: <4841143E.5080003@myri.com>
	<20080531185424.1cd18220@infradead.org>
	<48441F73.5040005@myri.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2008 18:27:31 +0200
Brice Goglin <brice@myri.com> wrote:


> 
> Agreed, that would be nice!
> 
> >From what we discussed here after your reply, our plan is now to just
> replace
>     ioremap+mtrr_add

which doesn't work as ioremap() may/will force uncached ;)


> with
>     ioremap_wc+mtrr_add
> 
> If mtrr_add() is moved into ioremap_wc(), we'll remove it from
> myri10ge. For now, when PAT is enabled, we may have PAT + MTRR both
> doing WC, but I don't think it can break anything, right?

Both having WC is nicely consistent and the right thing happens...

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
