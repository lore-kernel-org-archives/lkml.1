Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbZFCGg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbZFCGg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 02:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZFCGgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 02:36:20 -0400
Received: from claw.goop.org ([74.207.240.146]:50697 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbZFCGgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 02:36:20 -0400
Message-ID: <4A2619E1.60808@goop.org>
Date: Wed, 03 Jun 2009 16:36:17 +1000
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Christophe Saout <chtephan@leto.intern.saout.de>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 14/16] paravirtualize IO permission bitmap
References: <1242163718-2934-1-git-send-email-jeremy@goop.org> <1242163718-2934-15-git-send-email-jeremy@goop.org> <alpine.LFD.2.00.0906021751510.3419@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0906021751510.3419@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
>   Sigh, is there a plan to limit the paravirt horror at some point or
>   are we keeping on adding to it forever ?
>   

There haven't been any new ops added in a long time.  We've had one for 
iopl for a long while; this fills it out to be fully functional.  I 
don't see a need for any more ops with the current architecture.

    J
