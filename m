Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592AbZIIR3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbZIIR3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 13:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbZIIR3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 13:29:36 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:38499 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753479AbZIIR3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 13:29:35 -0400
Date: Wed, 9 Sep 2009 13:28:24 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Jeff Layton <jlayton@redhat.com>
cc: linux-kernel@vger.kernel.org, samba@lists.samba.org,
       linux-cifs-client@lists.samba.org
Subject: Re: 2.6.31-rc8: CIFS with 5 seconds hiccups
In-Reply-To: <20090909132039.1ca47cd4@tlielax.poochiereds.net>
Message-ID: <alpine.DEB.1.10.0909091327370.32067@V090114053VZO-1>
References: <alpine.DEB.1.10.0909041217520.7209@V090114053VZO-1> <20090905071052.50501826@tlielax.poochiereds.net> <alpine.DEB.1.10.0909091009120.28070@V090114053VZO-1> <20090909125352.1c7b57d2@tlielax.poochiereds.net> <alpine.DEB.1.10.0909091304001.32067@V090114053VZO-1>
 <20090909132039.1ca47cd4@tlielax.poochiereds.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009, Jeff Layton wrote:

> That'll stop your client from requesting oplocks, but that won't
> prevent others from doing so. If my suspicion is correct, then another
> client is holding an oplock and the server needs to break it before it
> can reply to yours.
>
> Unfortunately I doubt there's much you can do from your client to
> prevent that (if that is the case). There may be a way to turn off
> oplocks on the server side, but that may very well be even worse for
> performance.

Hmmm... We can look at that.

Another interesting tidbit is that I have never seen this from a 64 bit
Linux kernel. Only occurs with 32 bit kernels it seems.

