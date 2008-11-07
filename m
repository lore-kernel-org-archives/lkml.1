Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbYKGBAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbYKGBAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 20:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbYKGBAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 20:00:15 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34279 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbYKGBAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 20:00:13 -0500
Date: Fri, 7 Nov 2008 00:59:46 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Zhao Yakui <yakui.zhao@intel.com>
Cc: Len Brown <lenb@kernel.org>, Andrey Borzenkov <arvidjaar@mail.ru>,
       Ingo Molnar <mingo@elte.hu>, Eduardo Habkost <ehabkost@redhat.com>,
       Avi Kivity <avi@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 15/15] Revert "x86: default to reboot via ACPI"
Message-ID: <20081107005946.GA9254@srcf.ucam.org>
References: <1225915018-6548-1-git-send-email-ehabkost@redhat.com> <20081106143021.GD13023@elte.hu> <20081106150610.GA1644@elte.hu> <200811061853.08003.arvidjaar@mail.ru> <alpine.LFD.2.00.0811061442590.3106@localhost.localdomain> <20081106215011.GA6391@srcf.ucam.org> <alpine.LFD.2.00.0811061716420.3106@localhost.localdomain> <1226019679.3989.107.camel@yakui_zhao.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226019679.3989.107.camel@yakui_zhao.sh.intel.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 09:01:19AM +0800, Zhao Yakui wrote:

> With the help of KVM I find that the windows will be rebooted by writing
> RESET_VALUE to RESET_REG I/O port if the RESET_REG_SUP bit is not
> zero(It indicates whether ACPI reboot is supported).
> IMO maybe the ACPI reboot is the first choice. If it can't, then it will
> fall back to other mode.

Hmm. But we're seeing some machines that end up very confused if 
rebooted via ACPI. I guess we need to run Vista on them to find out how 
they behave. What OSI strings did your KVM setup expose? We know that 
Windows changes behaviour under various circumstances depending on which 
OS the firmware requests, so it's almost possible that this is another 
of those cases.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
