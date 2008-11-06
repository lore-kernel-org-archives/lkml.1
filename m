Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbYKFXYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbYKFXYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 18:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbYKFXYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 18:24:40 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:49715 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbYKFXYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 18:24:39 -0500
Date: Thu, 6 Nov 2008 23:24:19 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Len Brown <lenb@kernel.org>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, Ingo Molnar <mingo@elte.hu>,
       Eduardo Habkost <ehabkost@redhat.com>, Avi Kivity <avi@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 15/15] Revert "x86: default to reboot via ACPI"
Message-ID: <20081106232419.GA8007@srcf.ucam.org>
References: <1225915018-6548-1-git-send-email-ehabkost@redhat.com> <20081106143021.GD13023@elte.hu> <20081106150610.GA1644@elte.hu> <200811061853.08003.arvidjaar@mail.ru> <alpine.LFD.2.00.0811061442590.3106@localhost.localdomain> <20081106215011.GA6391@srcf.ucam.org> <alpine.LFD.2.00.0811061716420.3106@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811061716420.3106@localhost.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 05:17:25PM -0500, Len Brown wrote:
> > Does Windows default to using the ACPI method now?
> 
> That is my guess, based on the fact that we've seen
> newer machines that don't reboot w/o using the ACPI reset reg.

We've seen machines that won't reboot for a variety of reasons in the 
past. In some cases this has seemed to be due to hardware being in a 
state that the BIOS didn't expect. Hitting the SMI trap behind the ACPI 
register might work around this, but I suspect that in many cases we 
could achieve the same effect by spending more time trying to work out 
whether there's any common themes in the failures.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
