Return-Path: <linux-kernel-owner+w=401wt.eu-S1753852AbZKDCAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbZKDCAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 21:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbZKDCAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 21:00:46 -0500
Received: from smtp-out.google.com ([216.239.33.17]:32847 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbZKDCAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 21:00:46 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=pJcxNy3zMiGJHXullDvXXGuqhDBM50UoAKHij+iegylWZ25P5JIu6Mn+bw1zbcnmW
	kxoQOnHpZ4MTYF++Gel8w==
Date: Tue, 3 Nov 2009 18:00:43 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alex Chiang <achiang@hp.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Badari Pulavarty <pbadari@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch -mm] mm: slab allocate memory section nodemask for large
 systems
In-Reply-To: <20091102204726.GG5525@ldl.fc.hp.com>
Message-ID: <alpine.DEB.2.00.0911031759350.1187@chino.kir.corp.google.com>
References: <20091022040814.15705.95572.stgit@bob.kio> <20091022041510.15705.5410.stgit@bob.kio> <alpine.DEB.2.00.0910221249030.26631@chino.kir.corp.google.com> <20091027195907.GJ14102@ldl.fc.hp.com> <alpine.DEB.2.00.0910271422090.22335@chino.kir.corp.google.com>
 <20091028083137.GA24140@osiris.boeblingen.de.ibm.com> <alpine.DEB.2.00.0910280159380.7122@chino.kir.corp.google.com> <20091028183905.GF22743@ldl.fc.hp.com> <alpine.DEB.2.00.0910281315370.23279@chino.kir.corp.google.com>
 <20091102204726.GG5525@ldl.fc.hp.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009, Alex Chiang wrote:

> Any comments on this patch series?
> 
> Turns out that Kame-san's fear about a memory section spanning
> several nodes on certain architectures (S390) isn't really
> applicable and even if it were, we have code to handle situation
> anyway.
> 
> Kame-san was generally supportive of these convenience symlinks
> although he did not give a formal ACK.
> 
> David has given an ACK on the two patches that do real work, as
> well as supplied the below patch.
> 
> I can respin this series once more, including David's Acked-by:
> and adding his patch if that makes life easier for you.
> 

It's probably in Andrew's queue after getting back from the kernel summit, 
it would be best to wait a week or so.
