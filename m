Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbYI2Hhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbYI2Hhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 03:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYI2Hhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 03:37:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60040 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbYI2Hhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 03:37:45 -0400
Message-ID: <48E085B3.1080507@redhat.com>
Date: Mon, 29 Sep 2008 10:37:23 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Alok Kataria <akataria@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Dan Hecht <dhecht@vmware.com>, Jun.Nakajima@Intel.Com
Subject: Re: Use CPUID to communicate with the hypervisor.
References: <1222472815.29886.43.camel@alok-dev1> <20080929065557.GB9952@redhat.com>
In-Reply-To: <20080929065557.GB9952@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gleb Natapov wrote:
> Can this interface be used to pass variable sized data from a hypervisor
> to a gust? ACPI or DMI tables for instance.
>
>   

In theory it can, but it would be a bad idea.  cpuid is best used to 
communicate cpu features; ACPI and DMI are (mostly) system features.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

