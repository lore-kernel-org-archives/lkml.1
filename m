Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbZCHOay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbZCHOay (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 10:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbZCHOaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 10:30:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57848 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbZCHOaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 10:30:21 -0400
Message-ID: <49B3D678.4050004@redhat.com>
Date: Sun, 08 Mar 2009 16:30:16 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Yu Zhao <yu.zhao@intel.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Yang, Sheng" <sheng.yang@intel.com>
Subject: Re: [PATCH v10 0/7] PCI: Linux kernel SR-IOV support
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <49A3D04A.9010501@redhat.com> <20090306193329.GB25995@parisc-linux.org>
In-Reply-To: <20090306193329.GB25995@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Feb 24, 2009 at 12:47:38PM +0200, Avi Kivity wrote:
>   
>> Do those patches allow using a VF on the host (in other words, does the 
>> kernel emulate config space accesses)?
>>     
>
> SR-IOV hardware handles config space accesses to virtual functions.  No
> kernel changes needed for that aspect of it.
>   

Patches 2 and 3 of the patchset that enables SR/IOV in kvm [1] suggest 
that at the config space is only partially implemented.

[1] http://thread.gmane.org/gmane.comp.emulators.kvm.devel/29034

-- 
error compiling committee.c: too many arguments to function

