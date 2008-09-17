Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbYIQT1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbYIQT1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 15:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYIQT0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 15:26:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42319 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbYIQT0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 15:26:49 -0400
Message-ID: <48D159A7.5080907@zytor.com>
Date: Wed, 17 Sep 2008 12:25:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] loglevel=pci:8,acpi:8,apic=8 support v6
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com> <20080917015543.27172da4.akpm@linux-foundation.org> <20080917092732.GB32107@elte.hu> <20080917184618.GB6486@redhat.com>
In-Reply-To: <20080917184618.GB6486@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Baron wrote:
> 
> hi,
> 
> indeed both proposals seem to be addressing a similar core issue - being
> able to dynamically (as opposed to re-compiling) change the amount of
> verbosity that the kernel spews. I would liken it to adding a -verbose
> flag to the kernel.
> 
> Beyond that the 2 approaches differ in a number of ways as I see:
> 

8) The ability to accessed filtered messages a posteori (via dmesg), 
which is something we currently take for granted.

This *is* the fundamental difference between what Yinghai has now and 
both your stuff and Yinghai's original proposal.  Not producing the 
additional messages at all is inherently cheaper, sometimes *much* 
cheaper, but it obviously means the information is not accessible at all.

At the moment, I would argue that the fact that dmesg is, in effect, 
more verbose than the kernel itself is a good thing; it makes dmesg 
dumps more useful.

	-hpa
