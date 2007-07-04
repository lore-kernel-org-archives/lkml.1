Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbXGDQpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbXGDQpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 12:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757544AbXGDQou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 12:44:50 -0400
Received: from gw.goop.org ([64.81.55.164]:42369 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757509AbXGDQos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 12:44:48 -0400
Message-ID: <468BCE7F.107@goop.org>
Date: Wed, 04 Jul 2007 09:44:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: Re: [PATCH] x86: make SMP locks handling interact properly with CONFIG_DEBUG_RODATA
 (2nd try)
References: <468B5B54.76E4.0078.0@novell.com> <468BBFB3.9080303@goop.org> <200707041815.58923.ak@suse.de>
In-Reply-To: <200707041815.58923.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Not if the patching happens early enough at boot. That's true for Xen
> and lguest, but I'm not sure about VMI

paravirt_ops patching happens at the same time as all other patching, 
via check_bugs().  So its the same regardless of backend, and quite late.

    J

