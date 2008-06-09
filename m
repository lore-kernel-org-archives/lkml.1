Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbYFITjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbYFITjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbYFITix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:38:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:29259 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbYFITiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:38:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Dq7w6pNRE3rMXPbMI3PciYq1YS9bTUlZOz6DuBcx9oY67qElF2/wWXsSrS67AHAS+V
         jo7Z8H8OvVclF8VbZZ2/Tfhc1gw0iFK3diUbohEOvAJVuMJfXskfBjTA6tayWS8FM1U5
         WX1/yFVxubRs8lLAIso93rGKSw4XQZ15XUeEg=
Message-ID: <86802c440806091238o30ca6910w93163f45fd1419ae@mail.gmail.com>
Date: Mon, 9 Jun 2008 12:38:50 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: update mptable v7 - fix
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080609190911.GA20997@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805041823.57198.yhlu.kernel@gmail.com>
	 <200805251600.26325.yhlu.kernel@gmail.com>
	 <200806011317.38622.yhlu.kernel@gmail.com>
	 <200806081953.26877.yhlu.kernel@gmail.com>
	 <20080609101318.GA23873@elte.hu>
	 <86802c440806091051j30ac4480oe6be0a7b288f772c@mail.gmail.com>
	 <20080609190911.GA20997@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2008 at 12:09 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> thanks. So X86_MPPARSE is not needed when SMP is not enabled?
>
> here's the condition:
>
> config X86_MPPARSE
>        def_bool y
>        depends on (X86_32 && (X86_LOCAL_APIC && !X86_VISWS)) || X86_64
>
> 64-bit has it unconditionally, 32-bit has it on SMP, UP-IOAPIC or
> UP-local-APIC mode. [ (and VISWS is an ugly complication we should try
> to eradicate similarly to NUMAQ, if possible :-) ]

VISWS or VOYAGER depends on !PCI, that is some odd system.

YH
