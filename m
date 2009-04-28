Return-Path: <linux-kernel-owner+w=401wt.eu-S1760183AbZD1Kg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183AbZD1Kg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759845AbZD1KgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:36:11 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:23403 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759685AbZD1KgJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:36:09 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Apr 2009 06:36:09 EDT
X-BigFish: VPS-25(zz1432R98dR1805M936fKzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KIT3ET-02-P8U-01
Date: Tue, 28 Apr 2009 12:20:54 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <marcelo@kvack.or>, <linux-kernel@vger.kernel.org>,
       <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/7] KVM support for 1GB pages v2
Message-ID: <20090428102054.GX17438@amd.com>
References: <1240574327-21575-1-git-send-email-joerg.roedel@amd.com> <49F6D767.9050801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <49F6D767.9050801@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 28 Apr 2009 10:20:55.0134 (UTC) FILETIME=[03C64FE0:01C9C7EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 01:16:07PM +0300, Avi Kivity wrote:
> Joerg Roedel wrote:
>> Hi,
>>
>> this is the second version of the patches implementing support for 1GB
>> pages in KVM. There are too many changes to the first version to mention
>> them all here. The core support was rewritten to work with mapping
>> levels instead of page sizes. This was the main part of the change.
>> The patches still only support KVM with nested paging enabled
>
> What is missing to get shadow paging working with this?  I don't think  
> it's particularly important (it will be pretty hard to find a GB page  
> without any shadowed pages in it), but I don't like arbitrary 
> constraints.

1GB pages with shadow paging does not work yet. But I will post the
patch for it when it works stable for me. It makes sense at least if the
guest uses 1gb pages in hugetlbfs.

> walk_addr() needs to change to support GB pages, did I miss it in the  
> patchset?

Ah true. I missed that in this patchset. I will add it.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

