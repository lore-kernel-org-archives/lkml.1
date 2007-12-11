Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbXLKPwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbXLKPwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 10:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbXLKPwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 10:52:35 -0500
Received: from il.qumranet.com ([82.166.9.18]:57870 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbXLKPwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 10:52:34 -0500
Message-ID: <475EB23E.1060002@qumranet.com>
Date: Tue, 11 Dec 2007 17:52:30 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [RFC] Proposed new directory layout for kvm and	virtualization
References: <475E5CBB.9080608@qumranet.com> <20071211151143.GA7751@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20071211151143.GA7751@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> On Tue, Dec 11, 2007 at 11:47:39AM +0200, Avi Kivity wrote:
>   
>> KVM is due to receive support for multiple architectures (ppc, ia64, and 
>> s390, in addition to the existing x86), hopefully in time for the 2.6.25 
>> merge window.  It is awkward to place the new arch support in drivers/kvm/, 
>> so I'd like to propose the following new layout:
>> ...
>>  arch/*/kvm/   arch dependent kvm code
>>     
>
> Maybe arch/*/virt/ ? No need to add an own directory for each hypervisor.
>
>   

There will be several kvm files in that directory for x86. If you have 
just one file, I guess arch/*/virt/kvm.c is okay.

-- 
error compiling committee.c: too many arguments to function

