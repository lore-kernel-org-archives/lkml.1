Return-Path: <linux-kernel-owner+w=401wt.eu-S1758870AbZHRMaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870AbZHRMaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 08:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758760AbZHRMaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 08:30:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42293 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbZHRMaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 08:30:12 -0400
Message-ID: <4A8A9E94.9020700@redhat.com>
Date: Tue, 18 Aug 2009 15:29:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Gregory Haskins <GHaskins@novell.com>
CC: mingo@elte.hu, gregory.haskins@gmail.com,
       alacrityvm-devel@lists.sourceforge.net, mst@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model	 for
References: <4A8A654A0200005A000528E7@sinclair.provo.novell.com> <4A8A65540200005A000528EA@sinclair.provo.novell.com> <4A8A65540200005A000528EA@sinclair.provo.novell.com>
In-Reply-To: <4A8A65540200005A000528EA@sinclair.provo.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2009 03:24 PM, Gregory Haskins wrote:
> (Again on the top post)
>
> No, Avi, nothing has changed to my knowledge.  I just saw that you and Michael were heading down the same path, so I thought I might interject that we've already covered that ground.
>
> As of right now, I am of the opinion that its not worth any change in the short term, and may be worth IOoHC in the long term (primarily so that mmios get a boost)
>    

The primary issue with IOoHC is that while hypercalls are faster than 
emulated mmio, they're much slower than assigned mmio.  So we have to 
distinguish between these two cases, which gets kinda icky.

-- 
error compiling committee.c: too many arguments to function

