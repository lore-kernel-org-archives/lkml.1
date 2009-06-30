Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046AbZF3P6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbZF3P6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 11:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbZF3P6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 11:58:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46194 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbZF3P6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 11:58:20 -0400
Date: Tue, 30 Jun 2009 18:58:20 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi@redhat.com" <avi@redhat.com>, ebiederm@xmission.com
Subject: Re: [PATCH v4] enable x2APIC without interrupt remapping under KVM
Message-ID: <20090630155820.GC8122@redhat.com>
References: <20090630064515.GG20289@redhat.com> <86802c440906300018p8c5156dy3e8d84b8c263797e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440906300018p8c5156dy3e8d84b8c263797e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 12:18:19AM -0700, Yinghai Lu wrote:
> how about kexec second kernel in KVM ?
> 
> x2apic_preenabled will be set in second kernel.
> 
By the way anybody knows why kexec does not use BIOS reset code
(cmos 0xf offset) to jump into new kernel after hard reset?

--
			Gleb.
