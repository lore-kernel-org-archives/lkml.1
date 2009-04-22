Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbZDVVH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbZDVVH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 17:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbZDVVHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 17:07:38 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:40812 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbZDVVHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 17:07:37 -0400
Date: Wed, 22 Apr 2009 16:59:23 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Steven Whitehouse <swhiteho@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] __ffs64()
In-Reply-To: <1240415192.29604.90.camel@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0904221654370.32682@qirst.com>
References: <1240415192.29604.90.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009, Steven Whitehouse wrote:

> I'd like to add a new bitop, __ffs64() which I need in order to fix a
> bug in GFS2. The question is, where should it go?

I think the location is right.

> On 64 bit arches, __ffs64() would be a synonym for __ffs(), but on 32
> bit arches it degenerates to a conditional plus a call to __ffs(). I'm
> assuming that there would not be a lot of point in optimising this
> operation on 32 bit arches even if such an instruction was available, so
> that I should do something like the below patch.
>
> Does that seem reasonable, or should I give it a separate header file
> under asm-generic/bitops/ like some of the similar operations? It looks
> like I'd have to touch a lot of other files if I were to go that route,

One issue may be that some 32 bit architectures have a better way of doing
64 bit ffs.

