Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbYKCOmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbYKCOmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 09:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbYKCOmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 09:42:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57461 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577AbYKCOmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 09:42:25 -0500
Message-ID: <490F0DA3.4090108@redhat.com>
Date: Mon, 03 Nov 2008 16:41:39 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Eduardo Habkost <ehabkost@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrey Borzenkov <arvidjaar@mail.ru>,
       mingo@redhat.com, Andrew Morton <akpm@osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] Use BIOS reboot on Toshiba Portege 4000
References: <200810312118.45368.arvidjaar@mail.ru> <20081103090843.GI11730@elte.hu> <490ECC4D.9090704@redhat.com> <20081103133306.GZ23893@blackpad>
In-Reply-To: <20081103133306.GZ23893@blackpad>
Content-Type: text/plain; charset=x-gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduardo Habkost wrote:
> We probably need to disable vmx on all CPUs, but emergency reboot skips
> native_smp_send_stop() (where we could hook a virt_disable call in).
>
> As relying on IPIs defeats the whole point of emergency_restart, a proper
> fix will need to use NMIs like the kdump code does.
>   

They should use the same code; they have a similar environment at entry 
and reliability requirements for e_r are not greater than kdump's.

-- 
error compiling committee.c: too many arguments to function

