Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbYKIKMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbYKIKMw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 05:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbYKIKMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 05:12:41 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41890 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbYKIKMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 05:12:40 -0500
Message-ID: <4916B737.7050107@redhat.com>
Date: Sun, 09 Nov 2008 12:11:03 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Zhao Yakui <yakui.zhao@intel.com>, Len Brown <lenb@kernel.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>, Ingo Molnar <mingo@elte.hu>,
       Eduardo Habkost <ehabkost@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 15/15] Revert "x86: default to reboot via ACPI"
References: <1225915018-6548-1-git-send-email-ehabkost@redhat.com> <20081106143021.GD13023@elte.hu> <20081106150610.GA1644@elte.hu> <200811061853.08003.arvidjaar@mail.ru> <alpine.LFD.2.00.0811061442590.3106@localhost.localdomain> <20081106215011.GA6391@srcf.ucam.org> <alpine.LFD.2.00.0811061716420.3106@localhost.localdomain> <1226019679.3989.107.camel@yakui_zhao.sh.intel.com> <20081107005946.GA9254@srcf.ucam.org>
In-Reply-To: <20081107005946.GA9254@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> Hmm. But we're seeing some machines that end up very confused if 
> rebooted via ACPI. I guess we need to run Vista on them to find out how 
> they behave. What OSI strings did your KVM setup expose? We know that 
> Windows changes behaviour under various circumstances depending on which 
> OS the firmware requests, so it's almost possible that this is another 
> of those cases.
>   

Isn't it the other way around?  The firmware changes behavior depending 
on how the OS identifies itself?

Reboot is a fixed feature IIRC, so it cannot change depending on 
identification strings.

-- 
error compiling committee.c: too many arguments to function

