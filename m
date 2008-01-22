Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYAVR4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYAVR4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 12:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYAVR4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 12:56:04 -0500
Received: from gw.goop.org ([64.81.55.164]:55451 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbYAVR4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 12:56:03 -0500
Message-ID: <47962E1D.2090308@goop.org>
Date: Tue, 22 Jan 2008 09:55:41 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Eduardo Pereira Habkost <ehabkost@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com, mtosatti@redhat.com
Subject: Re: [PATCH 0/4] paravirt_ops-64 compile fixes
References: <1200952133-31581-1-git-send-email-ehabkost@redhat.com> <20080122120207.GA30271@elte.hu> <20080122123450.GU7338@blackpad>
In-Reply-To: <20080122123450.GU7338@blackpad>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduardo Pereira Habkost wrote:
> If this is desirable for broader testing, we can make config PARAVIRT
> visible and selectable on menuconfig, even when there is no guest
> implementation being enabled. Should I do it?
>   

Yes please.

> Maybe should this force-paravirt mode be a kernel debugging option?
>   

No, just a plain CONFIG_PARAVIRT to turn it on and off independently of 
everything else.

    J
