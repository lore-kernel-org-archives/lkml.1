Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbZJVTva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbZJVTva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 15:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbZJVTv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 15:51:29 -0400
Received: from smtp-out.google.com ([216.239.45.13]:61936 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbZJVTv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 15:51:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=MghZdS2+aQ8wpXXYySF5T4psWWjhlMZcfwFxlBNISkRgPatQN7Jf7pJYFCGK4pZ4R
	weOTNehJhPgXEtS1BvDkQ==
Date: Thu, 22 Oct 2009 12:51:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alex Chiang <achiang@hp.com>
cc: akpm@linux-foundation.org, Gary Hade <garyhade@us.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2 1/5] mm: add numa node symlink for memory section in
 sysfs
In-Reply-To: <20091022041510.15705.5410.stgit@bob.kio>
Message-ID: <alpine.DEB.2.00.0910221249030.26631@chino.kir.corp.google.com>
References: <20091022040814.15705.95572.stgit@bob.kio> <20091022041510.15705.5410.stgit@bob.kio>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Oct 2009, Alex Chiang wrote:

> Commit c04fc586c (mm: show node to memory section relationship with
> symlinks in sysfs) created symlinks from nodes to memory sections, e.g.
> 
> /sys/devices/system/node/node1/memory135 -> ../../memory/memory135
> 
> If you're examining the memory section though and are wondering what
> node it might belong to, you can find it by grovelling around in
> sysfs, but it's a little cumbersome.
> 
> Add a reverse symlink for each memory section that points back to the
> node to which it belongs.
> 
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Gary Hade <garyhade@us.ibm.com>
> Cc: Badari Pulavarty <pbadari@us.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Alex Chiang <achiang@hp.com>

Acked-by: David Rientjes <rientjes@google.com>

Very helpful backlinks to memory section nodes even though I have lots of 
memory directories on some of my test machines :)
