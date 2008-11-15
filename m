Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbYKOMq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbYKOMq3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 07:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYKOMqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 07:46:19 -0500
Received: from outbound-mail-33.bluehost.com ([69.89.18.153]:36159 "HELO
	outbound-mail-33.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751319AbYKOMqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 07:46:18 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Nov 2008 07:46:18 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=uniscape.net;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Q9V8e2qkcxDaqItc5JXXLbEyomuC84bQUp7HQauYtjqBmTjc399WLwH9g0VwAeB4OMlDrwequvGQvEDzhnKuKGJ5QMV8dYmrnQZcveyal56H4CyR9BG5S1PndDfdFCSQ;
Message-ID: <491EC2DF.2070704@uniscape.net>
Date: Sat, 15 Nov 2008 20:38:55 +0800
From: Yu Zhao <yu.zhao@uniscape.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: "Zhao, Yu" <yu.zhao@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Alex Chiang <achiang@hp.com>, Roland Dreier <rdreier@cisco.com>,
       Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 6/6 v3] PCI: document the change
References: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F6@pdsmsx502.ccr.corp.intel.com> <20081001160706.GI13822@parisc-linux.org>
In-Reply-To: <20081001160706.GI13822@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {2990:host272.hostmonster.com:uniscape:uniscape.net} {sentby:smtp auth 58.41.76.172 authed with yu.zhao@uniscape.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Sat, Sep 27, 2008 at 04:28:45PM +0800, Zhao, Yu wrote:
>> +To register SR-IOV service, Physical Function device driver needs to call:
>> +       int pci_iov_register(struct pci_dev *dev,
>> +               int (*notify)(struct pci_dev *, u32), char **entries)
> 
> I think a better interface would put the 'notify' into the struct
> pci_driver.  That would make 'notify' a bad name .... how about
> 'virtual'?  There's also no documentation for the second parameter to
> 'notify'.

Yes, putting the callback function to the 'pci_driver' is better. Looks 
like the 'virtual' is not very descriptive (and it's a adj. while other 
callbacks are verb). Any other candidates?

Thanks,
Yu


