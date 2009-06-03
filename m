Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbZFCXg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbZFCXg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 19:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbZFCXgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 19:36:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752239AbZFCXgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 19:36:19 -0400
Date: Wed, 3 Jun 2009 16:36:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/9] exec_path 1/9: introduce ->exec_path and switch
 /proc/*/exe
In-Reply-To: <20090603230422.GB853@x200.localdomain>
Message-ID: <alpine.LFD.2.01.0906031633190.4880@localhost.localdomain>
References: <20090526113618.GJ28083@us.ibm.com> <20090526162415.fb9cefef.akpm@linux-foundation.org> <20090531215427.GA29534@x200.localdomain> <20090531151953.8f8b14b5.akpm@linux-foundation.org> <20090603230422.GB853@x200.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Jun 2009, Alexey Dobriyan wrote:
> 
> [PATCH 1/9] exec_path 1/9: introduce ->exec_path and switch /proc/*/exe

Ok, looks reasonable to me, and seems to remove more code than it adds, 
and makes even that smaller remaining code more readable.

That said, I suspect there are user-space loaders etc that set 
VM_EXECUTABLE by hand when mmap'ing the main executable. Will this get 
things right? Or do we even allow that?

Can you also add more commentary about the fundamental reasons you want to 
do this, rather than talking just about the implementation issues.

			Linus
