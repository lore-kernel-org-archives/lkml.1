Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbYKFKlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbYKFKlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 05:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbYKFKlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 05:41:14 -0500
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:46457 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753537AbYKFKlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 05:41:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=cRLlnkyf6dkVMIp72YthIQwG3cFZA7JfAFo2iAqgS/8a82X5Ys/Qkw0iUZ0C8aPwgUql4w3K1TKwh/9kLUj0AGVupxCULtvAX1HwhVOWWVFTvwwn9Swy4k56n0b0E7oYjMPItIPigxZ/ev0pBk+sBGngxy8jj/k4BhDvQsCxBxQ=  ;
X-YMail-OSG: OVYovwQVM1koV8WsxvrN4F4M27KDdZ4.295OJCf6ASIpFT7yWIHBXAjFenEKkYqEvjjFAvDogCBs6u3DCIOjW4labQBDOVzK2OJnhTdE2tmKSdLqOpo07RpzDgnmM4cxnx_z.RYwR28PF4WU28H8nKtFSYRFT46HM8I_.Om_14nWsAhahhJzDIlyO_g7
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] vmap: cope with vm_unmap_aliases before vmalloc_init()
Date: Thu, 6 Nov 2008 21:41:00 +1100
User-Agent: KMail/1.9.5
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
References: <49010D41.1080305@goop.org> <4911EB5C.4030901@goop.org> <20081106100234.GM4890@elte.hu>
In-Reply-To: <20081106100234.GM4890@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811062141.01437.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 November 2008 21:02, Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > Jeremy Fitzhardinge wrote:
> >> Xen can end up calling vm_unmap_aliases() before vmalloc_init() has
> >> been called.  In this case its safe to make it a simple no-op.
> >>
> >> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> >
> > Ping?  Nick, Ingo: do you want to pick these up, or shall I send them to
> > Linus myself?
>
> i've applied them to tip/core/urgent and will send them to Linus
> unless Nick or Andrew has objections.

Thanks, yeah ack from me on those. I'm generally expecting Andrew to
pick up and merge mm patches, but I guess he wasn't cc'ed this time.
Anyway, if Ingo gets them upstream, that would be fine too.

Thanks,
Nick
