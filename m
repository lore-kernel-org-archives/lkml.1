Return-Path: <linux-kernel-owner+w=401wt.eu-S1753591AbZDMS0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbZDMS0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 14:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbZDMS0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 14:26:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:7675 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbZDMS0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 14:26:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rcYK5bszphntijoLQZQvmFeu4t9qeQle8nejGLOiDq+EnowMsAflaZEZJVeGhajZ0b
         58Lwo6QgSI0JkbRDFzkmNz2b0EnzNLhKS1IQ4mgxhk0WjOEcHfVMfLv4kIkKpAa7eQDV
         VVoJws1/7tIDrycNVDA6bSJ+XALilgNDIGaRs=
Date: Mon, 13 Apr 2009 22:26:40 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, containers@lists.linux-foundation.org
Cc: xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/30] cr: x86_64 support
Message-ID: <20090413182640.GA7263@x200.localdomain>
References: <20090410023649.GO27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410023649.GO27788@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 06:36:49AM +0400, Alexey Dobriyan wrote:
> Now x86 matrix of migration is:
> 
> 	task/kernel		kernel
> 	------------------------------
> 	i386/i386	=>	i386
> 	i386/i386	=>	x86_64
> 	i386/x86_64	=>	i386
> 	i386/x86_64	=>	x86_64
> 	x86_64/x86_64	=>	x86_64

Hmm, x86_64 kernel i386 program => i386 kernel case doesn't work, should
be better in next iteration.
