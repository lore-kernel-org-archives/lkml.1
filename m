Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbYJDIyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbYJDIyP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 04:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbYJDIx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 04:53:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59886 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbYJDIx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 04:53:57 -0400
Message-ID: <48E72EFF.5040101@redhat.com>
Date: Sat, 04 Oct 2008 11:53:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Nakajima, Jun" <jun.nakajima@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       "akataria@vmware.com" <akataria@vmware.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
       Zach Amsden <zach@vmware.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors	and	Linux.
References: <1222881242.9381.17.camel@alok-dev1>	 <48E3B19D.6060905@zytor.com> <1222882431.9381.23.camel@alok-dev1>	 <48E3BC21.4080803@goop.org> <1222895153.9381.69.camel@alok-dev1> <48E3FDD5.7040106@zytor.com> <0B53E02A2965CE4F9ADB38B34501A3A15D927EA4@orsmsx505.amr.corp.intel.com> <48E422CA.2010606@zytor.com> <0B53E02A2965CE4F9ADB38B34501A3A15DCBA221@orsmsx505.amr.corp.intel.com> <48E6AB15.8060405@zytor.com> <0B53E02A2965CE4F9ADB38B34501A3A15DCBA325@orsmsx505.amr.corp.intel.com>
In-Reply-To: <0B53E02A2965CE4F9ADB38B34501A3A15DCBA325@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nakajima, Jun wrote:
> What's the significance of supporting multiple interfaces to the same guest simultaneously, i.e. _runtime_? We don't want the guests to run on such a literarily Frankenstein machine. And practically, such testing/debugging would be good only for Halloween :-).
>
>   

If you can only expose one interface, you need to have the user choose.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

