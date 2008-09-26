Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbYIZMsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbYIZMsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbYIZMry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:47:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42742 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbYIZMry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:47:54 -0400
Message-ID: <48DCD9D9.9080008@redhat.com>
Date: Fri, 26 Sep 2008 14:47:21 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Zachary Amsden <zach@vmware.com>, Alok Kataria <akataria@vmware.com>,
       Alok kataria <alokkataria1@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Yan Li <elliot.li.tech@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
       "rjmaomao@gmail.com" <rjmaomao@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
References: <20080221115452.GB13948@elte.hu>	 <20080907234510.GA24133@yantp.cn.ibm.com>	 <20080908140423.GG11993@elte.hu>	 <35f686220809241928k3669e30bi8a98b440443c4bff@mail.gmail.com>	 <48DB15DB.8040501@zytor.com> <1222317978.23524.117.camel@alok-dev1>	 <48DB1984.8020704@zytor.com> <1222318928.23524.121.camel@alok-dev1>	 <48DB1BCE.2070106@zytor.com>  <1222320201.23524.135.camel@alok-dev1>	 <1222375694.27056.179.camel@bodhitayantram.eng.vmware.com>	 <48DC09D9.7040204@zytor.com> <1222381254.27056.194.camel@bodhitayantram.eng.vmware.com> <48DC105D.9050803@zytor.com>
In-Reply-To: <48DC105D.9050803@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> This, of course, is what CPUID is for.

... except that it doesn't always work.  It requires vmx/svm, otherwise
cpuid doesn't trap and thus can't be filled by the hypervisor ...

cheers,
  Gerd

