Return-Path: <linux-kernel-owner+w=401wt.eu-S1031061AbXDXIh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031061AbXDXIh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031037AbXDXIh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:37:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58995 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031061AbXDXIh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:37:58 -0400
Date: Tue, 24 Apr 2007 09:37:37 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] powerpc pseries eeh: Convert to kthread API
Message-ID: <20070424083737.GA26814@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Paul Mackerras <paulus@samba.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
	Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org, linuxppc-dev@ozlabs.org
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <11769695763104-git-send-email-ebiederm@xmission.com> <20070422123155.GF20763@infradead.org> <17965.39866.351929.349735@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17965.39866.351929.349735@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 03:55:06PM +1000, Paul Mackerras wrote:
> Christoph Hellwig writes:
> 
> > The first question is obviously, is this really something we want?
> > spawning kernel thread on demand without reaping them properly seems
> > quite dangerous.
> 
> What specifically has to be done to reap a kernel thread?  Are you
> concerned about the number of threads, or about having zombies hanging
> around?

I'm mostly concerned about number of threads and possible leakage of
threads.  Linas already explained it's not a problem in this case,
so it's covered.
