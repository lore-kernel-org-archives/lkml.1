Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbZDMIKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbZDMIKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 04:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbZDMIKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 04:10:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:13444 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbZDMIKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 04:10:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UzTJ0YF+IPTNtSv1X3j23hTemNgBglqGiDjBEMtOpzQ0AXRDK4JBqzmF5T5qiPJkbl
         k5uL4Kl+D0vrkF4LW6K4pgYGS5ZDzTEpoayB8E/1swnx47i7UjWiegT6qs8Myp5XWnYk
         IbIWmiP8v7d1s1W/gh0pvNDsQJaMuez2fPgvI=
Date: Mon, 13 Apr 2009 12:10:50 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Brian Haley <brian.haley@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, hch@infradead.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 10/30] cr: core stuff
Message-ID: <20090413081050.GA4687@x200.localdomain>
References: <20090410023539.GK27788@x200.localdomain> <20090410093520.GH17962@elte.hu> <20090410114326.GC3311@x200.localdomain> <49DF718B.9050809@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DF718B.9050809@hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 12:19:23PM -0400, Brian Haley wrote:
> Alexey Dobriyan wrote:
> > And of course, I don't want to see multiline
> > 
> > 	vmflags &= ~(VM_READ|VM_WRITE|
> > 			[5 lines skipped]
> 
> Then why don't you:
> 
> #define VM_CR_FOO (VM_READ|VM_WRITE|...)
> 
> 	vmflags &= ~VM_CR_FOO;

This won't fix "multiline" part.
