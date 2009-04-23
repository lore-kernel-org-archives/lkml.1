Return-Path: <linux-kernel-owner+w=401wt.eu-S1759834AbZDWTlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834AbZDWTlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756401AbZDWTjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:39:44 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:44754 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736AbZDWTjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:39:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vUbvovAAYM6cmaKHCa1jy5RX2W5gsA1bzykvwxO8kumR8PSh5vnS0l9JlytGu1ialA
         nn2kCercljJjXc1aUdp4GGfvSrcPVCzD/xHuGkanqsR0Pz4wJVU/KPq5TFPNbIwrjiGt
         h9ZAEOlk48yETB1KmpHHrsf6XjC6596YULxZA=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0904231136390.20852@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0904231136390.20852@chino.kir.corp.google.com>
Date: Thu, 23 Apr 2009 22:39:39 +0300
X-Google-Sender-Auth: 8ea37de25656cbb1
Message-ID: <84144f020904231239i813959dobe85b8c56cbf8887@mail.gmail.com>
Subject: Re: [patch 1/2] slub: rename cpuslab_flush to cpu_slab_flush
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Thu, Apr 23, 2009 at 9:38 PM, David Rientjes <rientjes@google.com> wrote:
> There is already a `cpu_slabs' file to display the number of cpu slabs,
> so cpuslab_flush should follow this pattern.
>
> The first documentation of this file will be in a subsequent patch that
> adds Documentation/ABI/testing/sysfs-kernel-slab, so no stable guarantee
> has been made that the name of this file would not change.

I'm afraid I don't have enough asbestos in my underwear to try to
sneak this one past Linus.

A kernel ABI is an ABI even if it's not documented. Now, I wouldn't
mind getting flamed if we actually gained something from the change.
But just fixing a simple typo in sysfs files is not big enough a
reason for me to merge the patch.

That said, I love the second patch though and am more than happy to take it.

                                          Pekka
