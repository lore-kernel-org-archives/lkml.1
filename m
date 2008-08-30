Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbYH3WuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbYH3WuU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 18:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755535AbYH3WuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 18:50:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:62338 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbYH3WuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 18:50:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZBFYiHEvJrAVHkFCSwWt2lX0z6uzjYZCJ5fk+uF+C7Y243T+mMZEvwIUjPfdHCnL+E
         svPZAQyR7v8zZeIykKCc+rGJQ7JvyXTu+S8j2go//khdfDQrcovsC3LsWUf7xmEKIpHD
         nqCpx95OOVZDIG/U4tN3bGZ+x+j21dYMv0bZg=
Message-ID: <86802c440808301550s627dfcb0h7ff8971c8248703a@mail.gmail.com>
Date: Sat, 30 Aug 2008 15:50:01 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jordan Crouse" <jordan.crouse@amd.com>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0808301539391.3290@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0808291434110.3300@nehalem.linux-foundation.org>
	 <200808300030.32905.rjw@sisk.pl>
	 <alpine.LFD.1.10.0808301012060.3290@nehalem.linux-foundation.org>
	 <86802c440808301107n4561e815ldf53183c92a7bc93@mail.gmail.com>
	 <alpine.LFD.1.10.0808301141590.3290@nehalem.linux-foundation.org>
	 <86802c440808301210u6db1b4e7p4036bdc95db1a601@mail.gmail.com>
	 <alpine.LFD.1.10.0808301214310.3290@nehalem.linux-foundation.org>
	 <86802c440808301314t525d1b75r9afcc73857cf5c79@mail.gmail.com>
	 <alpine.LFD.1.10.0808301539391.3290@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 3:41 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Sat, 30 Aug 2008, Yinghai Lu wrote:
>>
>> in old kernel, after BAR3 request_filed, pci_assigned_unassigned
>> should get update resource for that... but it could find that big
>> space for it.

wait, THAT BAR is 64BIT capable, So kernel should assign 64bit range to it...
it request_resource fails...

>
> Exactly. So what happens is that it doesn't actually re-allocate it at
> all. Not that it is necessarily even possible - it's quite possible that
> that field is effectively locked some way and is read-only. Without
> knowing the chipset details, we can only guess.

not touch it at this time...

except Jordan could find some clue with the DOC.

YH
