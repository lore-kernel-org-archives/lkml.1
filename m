Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbYJVOv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbYJVOv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbYJVOvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:51:17 -0400
Received: from outbound-mail-143.bluehost.com ([67.222.38.33]:39687 "HELO
	outbound-mail-143.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750758AbYJVOvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:51:16 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2008 10:51:15 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=uniscape.net;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ksWN+t7jZHR4sYtoRvNA4dA1lyWpxtM/EeP+WihHola91HGNOnIRYSgze3LOj/2Ri9EKVEWnOo5ZYYgK1muy4TsJQ3QzqLsHLoqkkj6VWTnMCC6pYpqzrPKT6bCyqcxu;
Message-ID: <48FF3D94.5090001@uniscape.net>
Date: Wed, 22 Oct 2008 22:49:56 +0800
From: Yu Zhao <yu.zhao@uniscape.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Yu Zhao <yu.zhao@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 8/16 v6] PCI: add boot options to reassign resources
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com> <20081022084303.GH3773@yzhao12-linux.sh.intel.com> <200810220835.35866.bjorn.helgaas@hp.com>
In-Reply-To: <200810220835.35866.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {2990:host272.hostmonster.com:uniscape:uniscape.net} {sentby:smtp auth 58.38.26.55 authed with yu.zhao@uniscape.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Wednesday 22 October 2008 02:43:03 am Yu Zhao wrote:
>> This patch adds boot options so user can reassign device resources
>> of all devices under a bus.
>>
>> The boot options can be used as:
>> 	pci=assign-mmio=0000:01,assign-pio=0000:02
>> '[dddd:]bb' is the domain and bus number.
> 
> I think this example is incorrect because you look for ";" to
> separate options, not ",".

The semicolon is used to separate multiple parameters for assign-mmio 
and assign-pio. E.g., 'pci=assign-mmio=0000:01;0001:02;0004:03'. And the 
comma separates different parameters for 'pci='.
