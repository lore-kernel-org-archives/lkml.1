Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbZKSQ3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbZKSQ3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 11:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757177AbZKSQ3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 11:29:32 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:38826 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757051AbZKSQ3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 11:29:32 -0500
Subject: Re: virtio: Add memory statistics reporting to the balloon driver
 (V3)
From: Adam Litke <agl@us.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <aliguori@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, qemu-devel@nongnu.org,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <4B056EB8.9020509@redhat.com>
References: <1258643169.3464.3.camel@aglitke>
	 <1258643945.3464.5.camel@aglitke>  <4B0562A0.7040507@redhat.com>
	 <1258646331.3464.18.camel@aglitke>  <4B056EB8.9020509@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Thu, 19 Nov 2009 10:29:09 -0600
Message-ID: <1258648149.3464.23.camel@aglitke>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-19 at 18:13 +0200, Avi Kivity wrote:
> On 11/19/2009 05:58 PM, Adam Litke wrote:
> > On Thu, 2009-11-19 at 17:22 +0200, Avi Kivity wrote:
> >    
> >> On 11/19/2009 05:19 PM, Adam Litke wrote:
> >>      
> >>> Rusty and Anthony,
> >>> If I've addressed all outstanding issues, please consider this patch for
> >>> inclusion.  Thanks.
> >>>
> >>> +struct virtio_balloon_stat
> >>> +{
> >>> +	__le16 tag;
> >>> +	__le64 val;
> >>> +};
> >>> +
> >>>
> >>>        
> >> You're not doing endian conversion in the host?
> >>      
> > No.  I was following by example.  For the virtio_balloon, the existing
> > code is careful so that the guest always writes data in little endian.
> >    
> 
> I don't follow.  If the guest is careful to write little-endian, surely 
> the host must be equally careful to read little-endian?

That is true and, by my reading of the existing qemu virtio-balloon
device code, isn't virtio_balloon_set_config() on a big endian host
already broken?


-- 
Thanks,
Adam

