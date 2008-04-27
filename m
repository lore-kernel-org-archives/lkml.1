Return-Path: <linux-kernel-owner+w=401wt.eu-S1764112AbYD1B7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764112AbYD1B7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 21:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205AbYD1B7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 21:59:43 -0400
Received: from nschwqsrv02p.mx.bigpond.com ([61.9.189.234]:26582 "EHLO
	nschwqsrv02p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753767AbYD1B7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 21:59:42 -0400
Date: Mon, 28 Apr 2008 08:25:17 +0930
From: Alan Modra <amodra@bigpond.net.au>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: binutils@sourceware.org, linux-kernel@vger.kernel.org,
       "Patrick J. Volkerding" <volkerdi@slackware.com>
Subject: Re: ld: <...> internal error, aborting at arange-set.c line 202 in arange_set_new
Message-ID: <20080427225517.GA10190@bubble.grove.modra.org>
Mail-Followup-To: Jesper Juhl <jesper.juhl@gmail.com>,
	binutils@sourceware.org, linux-kernel@vger.kernel.org,
	"Patrick J. Volkerding" <volkerdi@slackware.com>
References: <alpine.LNX.1.00.0804272326320.14738@dragon.funnycrock.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.00.0804272326320.14738@dragon.funnycrock.com>
User-Agent: Mutt/1.5.9i
X-RPD-ScanID: Class unknown; VirusThreatLevel unknown, RefID str=0001.0A150204.48150456.005D,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 11:35:23PM +0200, Jesper Juhl wrote:
> ld: size of bfd_vma > size of splay_tree types
> ld: BFD (Linux/GNU Binutils) 2.18.50.0.4.20080208 internal error, aborting 
> at arange-set.c line 202 in arange_set_new

This was fixed in current CVS by
http://sourceware.org/ml/binutils-cvs/2008-02/msg00052.html

One workaround is to build binutils on a 64-bit host.

-- 
Alan Modra
Australia Development Lab, IBM
