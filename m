Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbYLaU16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbYLaU16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 15:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbYLaU1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 15:27:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:14029 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbYLaU1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 15:27:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q2al16tGN3Dm3MrvjSDcVCVTJit7FNpihHbKqJDUAbIOVDwCrT4ongm2mv/8sEGGnQ
         grQFXDqDgb1nriUPJl8D8227SIcSbNH+tdZB6b/Z23qoY4d3gpWl9R0UOyey7jJTtggS
         apt3EEwL48Uy4qZ1oZC9bx3dkVfcHTv0x6bEQ=
Date: Wed, 31 Dec 2008 23:27:44 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: david@lang.hm, Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: early exception error
Message-ID: <20081231202744.GA32152@localhost>
References: <alpine.DEB.1.10.0812301416550.16847@asgard.lang.hm> <87k59hur5f.fsf@basil.nowhere.org> <alpine.DEB.1.10.0812301737320.16936@asgard.lang.hm> <20081231093803.GA20882@localhost> <alpine.DEB.1.10.0812311110320.18334@asgard.lang.hm> <20081231183039.GE20882@localhost> <alpine.DEB.1.10.0812311204580.18334@asgard.lang.hm> <20081231191214.GF20882@localhost> <alpine.DEB.1.10.0812311316350.18569@asgard.lang.hm> <20081231202346.GH20882@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081231202346.GH20882@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Wed, Dec 31, 2008 at 11:23:46PM +0300]
...
| >>
| >> also you could just pass numa=off and check if it help.
| >> (even if it help it would not mean that problem are gone
| >> but become hidden)
| >
| > with numa=off the system looks like it gets a bit further
| >
| > http://linux.lang.hm/linux/IMG00031.jpg
| >
| > this is with framebuffer disabled, earlyprintk=vga bootmem_debug numa=off
| >
| > David Lang
| >
| 
| Thanks David, if I recognize correctly now it fails at
| vfs_caches_init. hmm...
| 
| 		- Cyrill -

no suprises - vfs_caches_init uses SLAB_PANIC and since
we seems to have "memory related" problems earlier now
we've been catched explicitly by slab code.

		- Cyrill -
