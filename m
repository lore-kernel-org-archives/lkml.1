Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbZDUNdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbZDUNdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 09:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbZDUNdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 09:33:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53167 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755594AbZDUNdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 09:33:24 -0400
Message-ID: <49EDCB1D.1010301@redhat.com>
Date: Tue, 21 Apr 2009 16:33:17 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: Xenner design and kvm msr handling
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>	 <49DE195D.1020303@redhat.com>	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>	 <49E08762.1010206@redhat.com> <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com> <49E337D7.5050502@redhat.com> <49EA515C.9000507@codemonkey.ws> <49EAE1F6.9050205@redhat.com> <49EC29D1.8040407@redhat.com> <49EC3198.9070902@redhat.com> <49EC3987.2040001@redhat.com> <49EC3AD6.3090905@redhat.com> <49EC5B2A.9080403@redhat.com> <49EC5C3A.6020108@redhat.com> <49EC68A7.8080403@redhat.com> <49EC6DEE.4070703@redhat.com> <49EC7797.7060004@redhat.com> <49EC7C5F.2000006@redhat.com> <49ED8E6D.80005@redhat.com> <49ED9C70.5010906@redhat.com> <49EDB0E0.5060101@redhat.com> <49EDBBBF.90509@redhat.com> <49EDC050.1040700@redhat.com>
In-Reply-To: <49EDC050.1040700@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann wrote:
> Not sure, have to dig into the xen code to figure.
>
> Could be xen doesn't remember the page in the first place.  They might 
> let the illegal instruction fault handler patch the opcode.  At least 
> I vaguely remember some discussions about that.
>
> Could be there isn't a interface to forgot the page.  "reboot" in xen 
> land is "destroy guest, restart it".

How do you unload a driver then?

What about kexec?

I'm glad we didn't do a hypercall page in kvm.

>> Sure, but later on, we may want to take advantage of kernel netback.
>
> Agree.  But right now I have more important stuff to worry about ;)

Still good to know what to expect later on.

-- 
error compiling committee.c: too many arguments to function

