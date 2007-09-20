Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbXITSl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbXITSl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 14:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbXITSlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 14:41:50 -0400
Received: from smtp-out.google.com ([216.239.45.13]:30298 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbXITSlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 14:41:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=M4F1Ck+bPzr1ijoJGQTSSf54Oc+vUI0yFL+4h6cS51ZBKrSyzjLVDL2eCZEmkXraK
	n3QePpRBViPdsJD+/VTPA==
Date: Thu, 20 Sep 2007 11:40:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Satyam Sharma <satyam@infradead.org>
cc: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, kexec-ml <kexec@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 5/4] [-mm patch] Rename macros returning the size.
In-Reply-To: <alpine.LFD.0.999.0709201746090.17093@enigma.security.iitk.ac.in>
Message-ID: <alpine.DEB.0.9999.0709201139000.14644@chino.kir.corp.google.com>
References: <46E9F6A9.8060500@mxs.nes.nec.co.jp> <46E9F942.5070007@mxs.nes.nec.co.jp> <20070914190350.011cdadb.akpm@linux-foundation.org> <46F204FD.6040303@mxs.nes.nec.co.jp> <46F2056E.6080601@mxs.nes.nec.co.jp>
 <alpine.LFD.0.999.0709201746090.17093@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007, Satyam Sharma wrote:

> > [PATCH 5/4] [-mm patch] Rename macros returning the size.
> >  The #define SIZE() should be renamed STRUCT_SIZE() since it's always 
> >  returning the size of the struct with a given name.  This would allow 
> >  TYPEDEF_SIZE() to simply become SIZE() since it need not be used 
> >  exclusively for typedefs. This idea is David Rientjes's.
> >  http://www.ussg.iu.edu/hypermail/linux/kernel/0709.1/1964.html
> > 
> > Thanks
> > Ken'ichi Ohmichi
> > 
> > ---
> > Signed-off-by: David Rientjes <rientjes@google.com>
> 
> Hmm, I think adding a s-o-b line for David here isn't quite correct.
> When someone reviews a patch and gives a suggestion, you only need to
> copy him on the next iteration (and he may ack it or whatever, if he
> wants) -- but adding a s-o-b line like that ends up (incorrectly)
> denoting that he came between the author-to-git-commit chain ...
> 

Feel free to add

	Acked-by: David Rientjes <rientjes@google.com>

since I've reviewed the patch and agree with it.
