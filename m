Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbYKFW6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbYKFW6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYKFW6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:58:25 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:65323 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbYKFW6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:58:24 -0500
Date: Thu, 06 Nov 2008 17:17:25 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 15/15] Revert "x86: default to reboot via ACPI"
In-reply-to: <20081106215011.GA6391@srcf.ucam.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg@redhat.com>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, Ingo Molnar <mingo@elte.hu>,
       Eduardo Habkost <ehabkost@redhat.com>, Avi Kivity <avi@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Message-id: <alpine.LFD.2.00.0811061716420.3106@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <1225915018-6548-1-git-send-email-ehabkost@redhat.com>
 <20081106143021.GD13023@elte.hu> <20081106150610.GA1644@elte.hu>
 <200811061853.08003.arvidjaar@mail.ru>
 <alpine.LFD.2.00.0811061442590.3106@localhost.localdomain>
 <20081106215011.GA6391@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > My expectation is that with the ACPI default, our problem
> > is working around a finite list of old machines that don't work;
> > while with the default KBD, our problem is working around
> > a potentially unbounded list of yet to be shipped machines
> > who may only be tested and work using the ACPI method.
> 
> Does Windows default to using the ACPI method now?

That is my guess, based on the fact that we've seen
newer machines that don't reboot w/o using the ACPI reset reg.

-Len
