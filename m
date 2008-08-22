Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbYHVCs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbYHVCs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 22:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbYHVCsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 22:48:17 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:12398 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbYHVCsP (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 22:48:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jseU/E784cwFUWY7CmiOF7Vv8sXDfi97bPcnHZ0Cl9yIonYzIwf25dIi404VjOSzME
         VRgBjpAL0HV4cQU2i7zoikSiiUJsJD0XkPmORGm1PtDYep1ajr11CZJQ4A3dYzHTZxXJ
         gpx/fmRWyHZBOd035/DVIwC8A0IAi/T4JvEts=
Message-ID: <6934efce0808211948kd12ba76k1ee847a0e08010e0@mail.gmail.com>
Date: Thu, 21 Aug 2008 19:48:13 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Greg Ungerer" <gerg@snapgear.com>
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Cc: "Jamie Lokier" <jamie@shareable.org>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <48AE0476.80109@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00C4.6060302@gmail.com> <20080821110749.GA1926@shareable.org>
	 <6934efce0808210711t686a88eci6eb294dbb54d68fe@mail.gmail.com>
	 <48AE0476.80109@snapgear.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That would be enough I think. If you could manually select
> which files are contiguous-and-uncompressed that would be
> useful for some too here.

So.... If you don't have an MMU when do you call ->fault?  Does the
noMMU code just loop through ->fault()ing all the pages in an mmap()?

> One thing for sure is that many people who do non-MMU setups
> are interested in XIP to get the space savings. These are very
> often small devices with very constrained RAM and flash. (For
> whatever it is worth single NOR flash only boards are common in
> these smaller form factors :-)

True.
