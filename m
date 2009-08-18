Return-Path: <linux-kernel-owner+w=401wt.eu-S1758959AbZHRNsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959AbZHRNsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 09:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758943AbZHRNsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 09:48:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60048 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758939AbZHRNsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 09:48:04 -0400
Message-ID: <4A8AB0FE.1010204@redhat.com>
Date: Tue, 18 Aug 2009 16:47:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Gregory Haskins <GHaskins@novell.com>, mingo@elte.hu,
       alacrityvm-devel@lists.sourceforge.net, mst@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model
References: <4A8A67ED0200005A000528F5@sinclair.provo.novell.com> <4A8A67F70200005A000528F8@sinclair.provo.novell.com> <4A8A67F70200005A000528F8@sinclair.provo.novell.com> <4A8AA0C6.805@redhat.com> <4A8AAA67.8060602@gmail.com>
In-Reply-To: <4A8AAA67.8060602@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2009 04:19 PM, Gregory Haskins wrote:
> Yeah, exactly.  I think MMIO is particularly challenging because I don't
> know if there are any bits left to use.  But like I said, its a problem
> for another day IMO.
>    

x86_64 only uses 48 bits out of the 64 bits in a virtual address, so 
there are several guaranteed-unused bits.

-- 
error compiling committee.c: too many arguments to function

