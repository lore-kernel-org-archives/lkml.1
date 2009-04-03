Return-Path: <linux-kernel-owner+w=401wt.eu-S1763806AbZDCVz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763806AbZDCVz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 17:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762982AbZDCVzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 17:55:10 -0400
Received: from smtp-out.google.com ([216.239.45.13]:57135 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761679AbZDCVzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 17:55:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=DSCo+zg4uTHhvGKGunqOVpM9MhrgcWjZUPrSjS+OT3yPP/GzUqv6w06v/jPVexQ3J
	vj1fLnPxiHyPihH6YMOkw==
Date: Fri, 3 Apr 2009 14:54:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: Chris Worley <worleys@gmail.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Off topic: Numactl "distance" wrong
In-Reply-To: <20090403215351.GF11935@one.firstfloor.org>
Message-ID: <alpine.DEB.2.00.0904031453170.4329@chino.kir.corp.google.com>
References: <f3177b9e0904031302p8aef826u1874a8b9d9af0840@mail.gmail.com> <87vdpljuqi.fsf@basil.nowhere.org> <alpine.DEB.2.00.0904031438540.3646@chino.kir.corp.google.com> <20090403215351.GF11935@one.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Apr 2009, Andi Kleen wrote:

> That's the same really. Think about it. No SLIT on a NUMA system is a wrong
> SLIT.
> 

Unless each node really is symmetrically distant from each other node, in 
which case the distance is reported correctly as a result of the differing 
pxms.
