Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297AbYIYFXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbYIYFXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 01:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbYIYFXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 01:23:22 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:54773 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751030AbYIYFXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 01:23:21 -0400
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alok kataria <alokkataria1@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Yan Li <elliot.li.tech@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
       "rjmaomao@gmail.com" <rjmaomao@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Daniel Hecht <dhecht@vmware.com>,
       Zach Amsden <zach@vmware.com>
In-Reply-To: <48DB1BCE.2070106@zytor.com>
References: <20080221115452.GB13948@elte.hu>
	 <20080907234510.GA24133@yantp.cn.ibm.com>	 <20080908140423.GG11993@elte.hu>
	 <35f686220809241928k3669e30bi8a98b440443c4bff@mail.gmail.com>
	 <48DB15DB.8040501@zytor.com> <1222317978.23524.117.camel@alok-dev1>
	 <48DB1984.8020704@zytor.com> <1222318928.23524.121.camel@alok-dev1>
	 <48DB1BCE.2070106@zytor.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 24 Sep 2008 22:23:21 -0700
Message-Id: <1222320201.23524.135.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-24 at 22:04 -0700, H. Peter Anvin wrote:
> Alok Kataria wrote:
> >>>
> >> You accessed a bloody I/O port!
> >>
> >> If you think it's harmless because it was an IN, you're sorely mistaken.
> >
> > Hi Peter,
> >
> > It would be really helpful if you could explain me when can this go
> > wrong or what kinds of problems can this cause on native hardware.
> >
> 
> You accessed an unknown I/O port.
> 
> This means you caused an unknown action in an unknown peripheral device.
> 
> This could cause ANYTHING to happen.


Hmm...what can a IN on an unknown port cause on native hardware, if a
port is not being used it would return 0xFFFFFFFF in eax, and if you
have a real device there (a sane one), what can IN result in apart from
reading some IO register/counter value in eax ?
If there is anything apart from the above 2 outcomes, please let me know
exactly what you mean.

Thanks,
Alok

