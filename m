Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbZJGF5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbZJGF5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 01:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbZJGF5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 01:57:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbZJGF5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 01:57:07 -0400
Message-ID: <4ACC2BAD.8010901@redhat.com>
Date: Wed, 07 Oct 2009 01:48:29 -0400
From: john cooper <john.cooper@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       john.cooper@redhat.com
Subject: Re: [PATCH 1/4] virtio_blk: deprecate the 1024-byte ID field.
References: <200909300248.09630.rusty@rustcorp.com.au> <200909300941.24736.borntraeger@de.ibm.com> <4ACA1CBC.8020402@redhat.com> <200910061951.47231.rusty@rustcorp.com.au>
In-Reply-To: <200910061951.47231.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Also, I've been convinced to just hand over the 20 byte serial number
> since we're revisiting this.  It's simple, and there's no clear consensus.

I'm fine with this approach as it is where
I originally started with this Sisyphus Patch.
My bias toward pressing the ATA identify
interface into service here was just to reuse
an existing interface and make life easier
from the perspective of the guest. 

On the subject of retrieving the S/N alone, this
is the form of the simplistic ioctl originally
used to do so:

    unsigned char sn[80];
      :
    sn[0] = sizeof(sn);
    ioctl(fd, VBLK_GET_SN, &sn);

-john

-- 
john.cooper@redhat.com
