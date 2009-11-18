Return-Path: <linux-kernel-owner+w=401wt.eu-S932083AbZKRQ4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbZKRQ4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757879AbZKRQ4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:56:41 -0500
Received: from mail2.shareable.org ([80.68.89.115]:53958 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903AbZKRQ4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:56:39 -0500
Date: Wed, 18 Nov 2009 16:56:30 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Rusty Russell <rusty@rustcorp.com.au>, qemu-devel@nongnu.org,
       Avi Kivity <avi@redhat.com>,
       virtualization <virtualization@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org, Adam Litke <agl@us.ibm.com>
Subject: Re: [Qemu-devel] Re: virtio: Add memory statistics reporting to the balloon driver (V2)
Message-ID: <20091118165630.GB28723@shareable.org>
References: <1258488996.2820.35.camel@aglitke> <1258490189.2820.37.camel@aglitke> <200911181200.39971.rusty@rustcorp.com.au> <4B040C82.6070901@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B040C82.6070901@codemonkey.ws>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Rusty Russell wrote:
> >The little-endian conversion of the balloon driver is a historical mistake
> >(no other driver does this).  Let's not extend it to the stats.
> 
> I think the mistake is that the other drivers don't do that.
> 
> We cheat in qemu and assume that the guest is always in a fixed 
> endianness but this is not always the case for all architectures.

If guests can have different endianness (reasonable on some CPUs where
it's switchable - some even have more than 2 options), then I guess
the *host* on those systems have different endianness too.

Is the host's endianness signalled to the guest anywhere, so that
guest drivers can do cpu_to_qemuhost32(), when someone eventually
finds that necessary?

-- Jamie
