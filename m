Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbYAOTcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbYAOTcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 14:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbYAOTcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 14:32:13 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50537 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbYAOTcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 14:32:13 -0500
Date: Tue, 15 Jan 2008 19:32:04 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Anton Salikhmetov <salikhmetov@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
       jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       protasnb@gmail.com, miklos@szeredi.hu
Subject: Re: [PATCH 1/2] Massive code cleanup of sys_msync()
Message-ID: <20080115193204.GA25866@infradead.org>
References: <12004129652397-git-send-email-salikhmetov@gmail.com> <12004129734126-git-send-email-salikhmetov@gmail.com> <20080115175705.GA21557@infradead.org> <4df4ef0c0801151102l4d72b6b5j702e21beb1ebe459@mail.gmail.com> <20080115111018.1e27a229.randy.dunlap@oracle.com> <4df4ef0c0801151126p5dfdbc13ga9862c995890c33c@mail.gmail.com> <1200425328.26045.39.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200425328.26045.39.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 08:28:48PM +0100, Peter Zijlstra wrote:
> Notice that error is already -EINVAL, so a simple goto should suffice.

Yes, for the start of the function you can basically leave it as-is.
