Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778Ab0A3Iym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab0A3Iym (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 03:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711Ab0A3Iyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 03:54:41 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:60540 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab0A3Iyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 03:54:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=OZmqtjoiUH7A9i9i9SLXaSBR83LQT9wShT8djKLUNgF5Rwzb0U3k3p17cBW8iLmJ1G
         3pNvLZa70SCJV/aAHODDUpN0iAtAwRMsEIWrnhrEBqwNVQ59Mmm4pF5ZhmrLfXNQWBRr
         kDssWHrH4TiN+bwgAHypgOu+kkfqRShF/B1pM=
MIME-Version: 1.0
In-Reply-To: <20100129204931.789743493@quilx.com>
References: <20100129204931.789743493@quilx.com>
Date: Sat, 30 Jan 2010 10:54:36 +0200
X-Google-Sender-Auth: f90660a9c0ce2205
Message-ID: <84144f021001300054k61ec7811j7df67635ef9049a9@mail.gmail.com>
Subject: Re: Slab Fragmentation Reduction V15
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Dave Chinner <david@fromorbit.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       Miklos Szeredi <miklos@szeredi.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 10:49 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> This is one of these year long projects to address fundamental issues in the
> Linux VM. The problem is that sparse use of objects in slab caches can cause
> large amounts of memory to become unusable. The first ideas to address this
> were developed in 2005 by various people. Some of the issues with SLAB that
> we discovered while prototyping these ideas also contributed to the locking
> design in SLUB which is highly decentralized and allows stabilizing the object
> state slab wise by taking a per slab lock.
>
> This patchset was first proposed in the beginning of 2007. It was almost merged
> in 2008 when last minute objections arose in the way this interacts with
> filesystem objects (inode/dentry).

Yeah, I think the SLUB bits were fine but there wasn't clear whether
or not the FS bits would be merged. No point in merging functionality
in SLUB unless it's going to be used.
