Return-Path: <linux-kernel-owner+w=401wt.eu-S1765165AbXF1Ryk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765165AbXF1Ryk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 13:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761309AbXF1Ryc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 13:54:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:51266 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761250AbXF1Ryb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 13:54:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N4WA0iP5Yq0abRq6W/Dc1KZTFM3CEE1IBxhKjBH0qo/rjkSe1Zkjr/EmqTQ3jUpsxGvSvRSv1rRwuICDDSBpYpfSLBnS4Ada6vJANqRg6SGUJPGA0axoKOU+yPaf2W+QU15ULCjPrC1F1p3wH4RhI/WkMOENKCTu5DeZxQ/J9BU=
Message-ID: <6278d2220706281054m476873ffn32375725fe5c4f88@mail.gmail.com>
Date: Thu, 28 Jun 2007 18:54:29 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: New format Intel microcode...
Cc: "Arjan van de Ven" <arjan@linux.intel.com>,
       "Bill Davidsen" <davidsen@tmr.com>, "Andi Kleen" <andi@firstfloor.org>,
       "Shaohua Li" <shaohua.li@intel.com>, jamagallon@ono.com,
       tigran@aivazian.fsnet.co.uk,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <4683EF87.1050303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220703221645j760a8816v4b8749ea2d60e493@mail.gmail.com>
	 <1174610594.6598.3.camel@sli10-conroe.sh.intel.com>
	 <6278d2220706261442u9b137c5xb6225b3f56605554@mail.gmail.com>
	 <p731wfy5m74.fsf@bingen.suse.de> <4683BD56.7070707@tmr.com>
	 <1183039975.14676.12.camel@laptopd505.fenrus.org>
	 <4683EF87.1050303@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/06/07, Chuck Ebbert <cebbert@redhat.com> wrote:
> On 06/28/2007 10:12 AM, Arjan van de Ven wrote:
[snip]
> >>  However, it listed only Windows related sites
> >> for the "fix" download. Is this the same TLB issue? And are these really
> >> fixes for Windows to flush the TLB properly the way Linux does?
> >
> > First of all, Linux has microcode updates as well. Some of the more
> > hypish news-bulletins just conveniently "forgot" about this. Basically
> > all distributions ship them, so users who use the distro update tools
> > get these automatically. And the update mentioned has been shipping for
> > a while (in version 1.17).
>
> Fedora 6 has version 1.13
> Fedora 7 also has 1.13
> RHEL 5 has 1.15
> Debian stable has 1.15 (9 Oct 2006)
> Suse 10.1 has 1.13

You've got to give credit to Intel for providing the ucode updates though.

The Ubuntu/Debian microcode.ctl package fetches a new version upon
installation/reconfiguration [1]; I guess if there were ucode updates
that resolved stability/vulnerability issues with Linux, the security
team could release an updated package with new default microcode.

However, I think the package isn't installed per default in Ubuntu
7.04 ia32/x86-64...

Daniel

--- [1]

# dpkg-reconfigure microcode.ctl
Local microcode is old, you need an update.
Trying to download an new version of microcode.
Now attempting to download microcode.
microcode downloaded sucessfully
-- 
Daniel J Blueman
