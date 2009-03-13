Return-Path: <linux-kernel-owner+w=401wt.eu-S1758997AbZCMRhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997AbZCMRhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755657AbZCMRhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:37:24 -0400
Received: from gw.goop.org ([64.81.55.164]:46664 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbZCMRhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:37:23 -0400
Message-ID: <49BA99D0.1040308@goop.org>
Date: Fri, 13 Mar 2009 10:37:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       jeremy.fitzhardinge@citrix.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: improve e820_search_gap()
References: <49B8F5C4.76E4.0078.0@novell.com>
In-Reply-To: <49B8F5C4.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Blindly putting the gap close after max_pfn might be fine for native
> (though even there I'm uncertain regarding memory hotplug), but will
> certainly present a problem on Xen. And properly searching for a gap
> above 4Gb shouldn't hurt native.
>   

What Xen-related issue are you thinking of?

When booting dom0 I reashape the guest memory to match the host E820 
map, and for domU my plan is to leave a hole at 3-4GB for pci 
passthrough resources.

    J
