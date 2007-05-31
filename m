Return-Path: <linux-kernel-owner+w=401wt.eu-S1761187AbXEaS34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761187AbXEaS34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758780AbXEaS3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:29:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48229 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758734AbXEaS3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:29:48 -0400
Date: Thu, 31 May 2007 19:29:45 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Stephane Eranian <eranian@hpl.hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/22] 2.6.22-rc3 perfmon2 : common core functions
Message-ID: <20070531182945.GA9747@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andi Kleen <andi@firstfloor.org>,
	Stephane Eranian <eranian@hpl.hp.com>, linux-kernel@vger.kernel.org
References: <200705291348.l4TDmRvL019775@frankl.hpl.hp.com> <p73ira9ca0d.fsf@bingen.suse.de> <20070531171616.GC23939@frankl.hpl.hp.com> <20070531172828.GC2538@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531172828.GC2538@one.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 07:28:28PM +0200, Andi Kleen wrote:
> I would prefer if oprofile would still work. It doesn't need to work
> in parallel but it should be possible to use it when perfmon
> is not active, but compiled in. That shouldn't be that difficult,
> should it?

I think the perform backend for oprofile is the right way to go.
I'd even go further and say we should merge the perfom backend with
oprofile as the only user first, because a) the current perfom user
interface is a complete mess and can't be merged as-is and b) that
ensures the oprofile backend works perfectly and we can kill some
existing code in exchange.

