Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbYGXAXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbYGXAXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 20:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbYGXAX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 20:23:28 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:34299 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754392AbYGXAX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 20:23:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EAFRnh0iWZWaT/2dsb2JhbACBWrFJ
X-IronPort-AV: E=Sophos;i="4.31,241,1215354600"; 
   d="scan'208";a="165530741"
Date: Thu, 24 Jul 2008 09:53:24 +0930
From: Kevin Shanahan <kmshanah@disenchant.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: libata timeout, MCE and kernel panic
Message-ID: <20080724002324.GK3930@cubit>
References: <20080723233509.GJ3930@cubit> <20080724004928.226f892a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724004928.226f892a@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 12:49:28AM +0100, Alan Cox wrote:
> > recovery was required. It seems the journal recovery combined with the
> > md device reconstruction was enough to cause an ata command
> > timeout. After that I saw several MCEs and the kernel paniced.
> 
> An MCE is amachine check, and indicates the hardware detected a problem.
> Given the sequence of heavy I/O, followed by a timeout and the processors
> detecting inconsistencies - is your PSU sufficient ?

Hmm, you may be on to something there. This machine was designed with
two disksoriginally, but due to a hardware failure on another machine
it's actually running with 5 (off a 450W redundant PSU). I have bigger
replacement PSUs on the way, so here's hoping that resolves it. Thanks
for the reply.

Regards,
Kevin.
