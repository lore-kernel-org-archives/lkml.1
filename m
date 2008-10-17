Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbYJQKC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbYJQKC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 06:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbYJQKCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 06:02:19 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:35057 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752036AbYJQKCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 06:02:18 -0400
Date: Fri, 17 Oct 2008 06:02:14 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] ext4: Replace hackish
	ext4_mb_poll_new_transaction with commit callback
Message-ID: <20081017100214.GB11557@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1224201763-9637-1-git-send-email-tytso@mit.edu> <20081017060424.GA26192@skywalker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017060424.GA26192@skywalker>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 11:34:25AM +0530, Aneesh Kumar K.V wrote:
> 
> Why not use journal commit callback patch from andreas 
> (MID:20080929201752.GN10950@webber.adilger.int
> http://article.gmane.org/gmane.comp.file-systems.ext4/9148)
> 
> The patch you sent will allows only one call back to be registered.
> 

Thanks for reminding me about that; I had completely forgotten about
Andreas' patch.  Sure, I'll respin the patch to use his extension.

	 	       	    	       	     	- Ted
