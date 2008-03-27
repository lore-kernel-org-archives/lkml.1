Return-Path: <linux-kernel-owner+w=401wt.eu-S1760841AbYC0QbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760841AbYC0QbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 12:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760463AbYC0QbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 12:31:00 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:44139 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbYC0Qa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 12:30:59 -0400
Subject: Re: [kvm-devel] kvm causing memory corruption?  ~2.6.25-rc6
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
In-Reply-To: <47EBC2F5.90302@qumranet.com>
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>
	 <47EA1C63.8010202@qumranet.com>
	 <1206550329.7883.5.camel@nimitz.home.sr71.net>
	 <47EA80AC.4070204@qumranet.com>
	 <1206551794.7883.7.camel@nimitz.home.sr71.net>
	 <47EB6AAC.3040607@qumranet.com>
	 <1206633002.7883.43.camel@nimitz.home.sr71.net>
	 <47EBC2F5.90302@qumranet.com>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 09:30:48 -0700
Message-Id: <1206635448.7883.78.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-27 at 17:53 +0200, Avi Kivity wrote:
> Dave Hansen wrote:
> > On Thu, 2008-03-27 at 11:36 +0200, Avi Kivity wrote:
> >   
> >> I dug out my i386 install and tried it.  Doesn't reproduce for me on 
> >> either kvm.git or -rc7.
> >>
> >> Do you have a working setup that we can bisect?
> >>     
> > I don't really have a working revision to bisect against.  I'm not sure
> > that it ever worked.  
> 
> I'm fairly sure Windows works on kvm...

Oh, I didn't mean to imply that Windows doesn't work, just that the
particular perverted way in which I'm poking it may have never
worked. :)

> How did you generate the image?

The original install was done in a kqemu-accelerated host. 

> > It's also on my actual laptop, so it's a bit of a
> > pain to get any other work done while I'm bisecting. :)
> >
> > I'll move the Windows image over to another machine today and see if I
> > can reproduce elsewhere.  I'll also check some older versions of KVM to
> > see if any of those work.  If I do that, should I keep the kvm
> > userspace, modules and BIOSes all synchronized from each version that I
> > test?
> >   
> 
> You can keep the userspace (qemu + bios) fixed and change the kernel, or 
> vice versa.
> 
-- Dave

