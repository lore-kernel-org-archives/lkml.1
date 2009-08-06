Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbZHFPpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbZHFPpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbZHFPpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:45:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47988 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755884AbZHFPpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 11:45:41 -0400
Message-ID: <4A7AFBE3.5080200@redhat.com>
Date: Thu, 06 Aug 2009 18:50:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Gregory Haskins <ghaskins@novell.com>,
       alacrityvm-devel@lists.sourceforge.net,
       "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/7] AlacrityVM guest drivers Reply-To:
References: <20090803171030.17268.26962.stgit@dev.haskins.net> <4A7AE150.7040009@redhat.com> <4A7AAB1A0200005A00051BED@sinclair.provo.novell.com> <200908061740.04276.arnd@arndb.de>
In-Reply-To: <200908061740.04276.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2009 06:40 PM, Arnd Bergmann wrote:
> 3. The ioq method seems to be the real core of your work that makes
> venet perform better than virtio-net with its virtqueues. I don't see
> any reason to doubt that your claim is correct. My conclusion from
> this would be to add support for ioq to virtio devices, alongside
> virtqueues, but to leave out the extra bus_type and probing method.
>    

The current conjecture is that ioq outperforms virtio because the host 
side of ioq is implemented in the host kernel, while the host side of 
virtio is implemented in userspace.  AFAIK, no one pointed out 
differences in the protocol which explain the differences in performance.

-- 
error compiling committee.c: too many arguments to function

