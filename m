Return-Path: <linux-kernel-owner+w=401wt.eu-S1759124AbZGGQxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124AbZGGQxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbZGGQxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:53:13 -0400
Received: from sg2ehsobe003.messaging.microsoft.com ([207.46.51.77]:12554 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755225AbZGGQxM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:53:12 -0400
X-SpamScore: -34
X-BigFish: VPS-34(zz146fK1432R98dN936eM1805M9371Pzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KMF87X-03-N71-01
Date: Tue, 7 Jul 2009 18:52:48 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <marcelo@kvack.org>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6 v4] KVM support for 1GB pages
Message-ID: <20090707165248.GR5380@amd.com>
References: <1246984867-15952-1-git-send-email-joerg.roedel@amd.com>
 <4A537C12.2040501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A537C12.2040501@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 07 Jul 2009 16:52:48.0450 (UTC) FILETIME=[5BB81A20:01C9FF23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 07:47:14PM +0300, Avi Kivity wrote:
> On 07/07/2009 07:41 PM, Joerg Roedel wrote:
> >Hi,
> >
> >this is the forth version of the patches for KVM to support 1GB pages.
> >This code still only can make use of 1GB pages with nested paging
> >enabled. I will give the shadow paging code another debug round soon.
> >Please comment or consider to apply these patches.
> >
> 
> I would really like to have shadow 1GB work, or at least gain some
> understanding of why it doesn't.
> 
> Can you detail the changes compared to the previous round?

Until now I addressed the review comments from the previous round. The
biggest change is patch #4 which was completly rewritten.
I understand that it would be nicer to have shadow paging working too.
But since most users will use this feature only on processors with
nested paging (only processors with nested paging support gbpages) I
don't think it should be a show-stopper. YMMV.
Anyway, I will further try to get shadow paging support running and
stable.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

