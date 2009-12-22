Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZLVTjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZLVTjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 14:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbZLVTjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 14:39:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146AbZLVTja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 14:39:30 -0500
Message-ID: <4B312042.7010804@redhat.com>
Date: Tue, 22 Dec 2009 21:38:42 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <20091218215107.GA14946@elte.hu> <4B2F9582.5000002@gmail.com> <20091222075742.GB26467@elte.hu> <4B3103B4.4070708@gmail.com> <4B3115C1.4070303@redhat.com> <4B311ADA.4000700@gmail.com> <4B311D20.7020400@redhat.com> <4B311ECB.6040205@gmail.com>
In-Reply-To: <4B311ECB.6040205@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2009 09:32 PM, Gregory Haskins wrote:
> xinterface, as it turns out, is a great KVM interface for me and easy to
> extend, all without conflicting with the changes in upstream.  The old
> way was via the kvm ioctl interface, but that sucked as the ABI was
> always moving.  Where is the problem?  ioeventfd still works fine as it is.
>    

It means that kvm locking suddenly affects more of the kernel.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

