Return-Path: <linux-kernel-owner+w=401wt.eu-S1759141AbZA2WBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759141AbZA2WBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbZA2WBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:01:30 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:41946 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752767AbZA2WBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:01:30 -0500
Message-ID: <49822738.5060103@vmware.com>
Date: Thu, 29 Jan 2009 14:01:28 -0800
From: Oleg Orel <oorel@vmware.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: "ashok.raj@intel.com" <ashok.raj@intel.com>,
       "shaohua.li@intel.com" <shaohua.li@intel.com>,
       "anil.s.keshavamurthy@intel.com" <anil.s.keshavamurthy@intel.com>,
       "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
       "avi@qumranet.com" <avi@qumranet.com>,
       "yaniv@qumranet.com" <yaniv@qumranet.com>,
       Bhavesh Davda <bhavesh@vmware.com>,
       Mallik Mahalingam <mallik@vmware.com>,
       Jagannath Krishnan <krishnan@vmware.com>, Adar Dembo <adar@vmware.com>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Intel IOMMU on Dell Latitude E6400, Lenovo X200 & Dell Precision
 T5400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Folks from Intel whi was working on IOMMU support in linux kernel and 
KVM folks who presumably been able to use it successfully, your 
input/comments will be very appriciated.

We are trying to make iommu working on laptops and desctop mentioned in 
the subject line. However, we on all three computers have exactly the 
same problem. We getting interrupt with 2 type of errors reported:

However, we are running into random device DMA issues on all three computers. We are getting MSI-X interrupts from the IOMMUs with 3 types of error reported:

a) PTE doesn't have write bit set
b) PTE doesn't have read bit set
c) Present bit in root entry is clear


We had reported more details @ 
https://bugzilla.redhat.com/show_bug.cgi?id=479996 and 
http://bugzilla.kernel.org/show_bug.cgi?id=11821


Please advice us a way to debug it, what peaces should we look at, 
print/check, etc...

1. Could we blame BIOS for that?
2. Is it possible that we build kernel with options what conflicting 
with iommu implementation in some way? If so, could you share your 
binary/source/config what works for you?
3. What desktop/laptops been tested and you aware that it works?
4. KVM folks, is it KVM+IOMMU works?
5. We have been seeing this issue with the latest Linus' git kernel as 
well as 2.6.29-rc3 from kernel.org.
Oleg
