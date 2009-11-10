Return-Path: <linux-kernel-owner+w=401wt.eu-S1758182AbZKJUz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182AbZKJUz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758129AbZKJUzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:55:55 -0500
Received: from smtp-out.google.com ([216.239.45.13]:28834 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758128AbZKJUzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:55:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=WuVQyydGmkG8IR1fMs6Y+I7P9eGWShxLwvjFCpGz99Td3Fc5RBUX1amKt2pnIgi1S
	7BsrCGS+o0F6Fn8/3ZQWg==
Date: Tue, 10 Nov 2009 12:55:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Alex Chiang <achiang@hp.com>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Badari Pulavarty <pbadari@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch -mm] mm: slab allocate memory section nodemask for large
 systems
In-Reply-To: <20091110125131.30376c03.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0911101255020.28728@chino.kir.corp.google.com>
References: <20091022040814.15705.95572.stgit@bob.kio> <20091022041510.15705.5410.stgit@bob.kio> <alpine.DEB.2.00.0910221249030.26631@chino.kir.corp.google.com> <20091027195907.GJ14102@ldl.fc.hp.com> <alpine.DEB.2.00.0910271422090.22335@chino.kir.corp.google.com>
 <20091028083137.GA24140@osiris.boeblingen.de.ibm.com> <alpine.DEB.2.00.0910280159380.7122@chino.kir.corp.google.com> <20091028183905.GF22743@ldl.fc.hp.com> <alpine.DEB.2.00.0910281315370.23279@chino.kir.corp.google.com> <20091102204726.GG5525@ldl.fc.hp.com>
 <20091110125131.30376c03.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009, Andrew Morton wrote:

> The prerequisite Documentation/ patches are a bit of a mess - some have
> been cherrypicked into Greg's tree I believe and some haven't.  So
> please also send out whatever is needed to bring linux-next up to date.
> 

I'm not aware of any prerequisites for this patchset, Alex's documentation 
changes have already been merged by Linus.
