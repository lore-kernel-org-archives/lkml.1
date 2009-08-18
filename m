Return-Path: <linux-kernel-owner+w=401wt.eu-S1758859AbZHRMUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859AbZHRMUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 08:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758807AbZHRMUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 08:20:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55359 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbZHRMUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 08:20:01 -0400
Message-ID: <4A8A9C69.6060900@redhat.com>
Date: Tue, 18 Aug 2009 15:19:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Gregory Haskins <GHaskins@novell.com>
CC: mst@redhat.com, mingo@elte.hu, gregory.haskins@gmail.com,
       alacrityvm-devel@lists.sourceforge.net, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model	 for	vbus_drive
References: <4A8A622E0200005A000528DC@sinclair.provo.novell.com> <4A8A62370200005A000528DF@sinclair.provo.novell.com> <4A8A62370200005A000528DF@sinclair.provo.novell.com>
In-Reply-To: <4A8A62370200005A000528DF@sinclair.provo.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2009 03:11 PM, Gregory Haskins wrote:
> Sorry for the toppost.  Still not at the office.
>
> I just wanted to add that we've already been through this disussion once.  (Search "haskins hypercall lkml" on google and I'm sure you are bound to see hits.
>
>    

Your numbers showed a 350ns difference on fairly old (by now) hardware.  
I doubt the difference will exceed 200ns now.

> The fact is: the original vbus was designed with hypercalls, and it drew much of these same critisims.  In the end, hypercalls are only marginally faster than PIO (iirc, 450ns faster, and shrinking), so we decided that it was not worth further discussion at the time.
>    

Has anything changed?

> A better solution is probably PIOoHC, so that you retain the best properties of both.  The only problem with the entire PIOx approach is that its x86 specific, but that is an entirely different thread.
>    

pio is nicely abstracted by PCI.  virtio-pci will use pio on x86 and 
mmio on non-x86.

-- 
error compiling committee.c: too many arguments to function

