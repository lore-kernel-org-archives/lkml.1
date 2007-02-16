Return-Path: <linux-kernel-owner+w=401wt.eu-S1946059AbXBPVEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946059AbXBPVEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 16:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946208AbXBPVEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 16:04:54 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:38005 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946059AbXBPVEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 16:04:53 -0500
Message-ID: <45D61C74.2000601@vmware.com>
Date: Fri, 16 Feb 2007 13:04:52 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch 00/21] Xen-paravirt: Xen guest implementation for paravirt_ops
 interface
References: <20070216022449.739760547@goop.org> <Pine.LNX.4.64.0702161244380.26718@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0702161244380.26718@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 15 Feb 2007, Jeremy Fitzhardinge wrote:
>
>   
>> This patch series implements the Linux Xen guest in terms of the
>> paravirt-ops interface.  The features in implemented this patch series
>>     
>
> I am thoroughly confused. Maybe that is because I have not been following 
> this issue closely but it seems that you are using the paravirt interface 
> as an API for Xen code in the guest? I thought the idea of paravirt was to 
> have an API that is generic? This patchset seems to be mostly realizing 
> Xen specific functionality? How does the code here interact with KVM, 
> VMWare and other hypervisors?
>   

For the most part, it doesn't disturb VMware or KVM.  Xen does need some 
additional functionality in paravirt-ops because they took a different 
design choice - direct page tables instead of shadow page tables.  This 
is where all the requirements for the new Xen paravirt-ops hooks come from.

Zach
