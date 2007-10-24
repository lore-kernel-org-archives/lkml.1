Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbXJXT5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbXJXT5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 15:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbXJXT4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 15:56:54 -0400
Received: from gw.goop.org ([64.81.55.164]:42675 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbXJXT4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 15:56:53 -0400
Message-ID: <471FA379.6070400@goop.org>
Date: Wed, 24 Oct 2007 12:56:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Jan Beulich <jbeulich@novell.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_XEN dependencies
References: <471DE2F8.76E4.0078.0@novell.com> <471E38D6.5050202@xensource.com> <471F1EEE.76E4.0078.0@novell.com> <471F965B.6090200@goop.org> <20071024195348.GM17536@waste.org>
In-Reply-To: <20071024195348.GM17536@waste.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> You might want a runtime check for these features as a future Xen
> hypervisor might eliminate these requirements.
>
> Ok, not really likely, but still possible.
>   

Seems pretty unlikely. All existing guests assume cmpxchg is available,
and the hypercall ABI depends on the tsc.

J
