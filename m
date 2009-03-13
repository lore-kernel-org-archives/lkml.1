Return-Path: <linux-kernel-owner+w=401wt.eu-S1759008AbZCMPRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008AbZCMPRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 11:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757687AbZCMPRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 11:17:11 -0400
Received: from gw.goop.org ([64.81.55.164]:55875 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755808AbZCMPRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 11:17:10 -0400
Message-ID: <49BA78F0.1070105@goop.org>
Date: Fri, 13 Mar 2009 08:17:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 22/24] xen: remove suspend_cancel hook
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>	<1236931920-6861-23-git-send-email-jeremy@goop.org> <49BA3EA7.76E4.0078.0@novell.com>
In-Reply-To: <49BA3EA7.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Does that mean that there are no intentions to ever support the accelerator
> stuff found in the 2.6.18-based Xenified Linux tree? That was the apparent
> only user of the cancel hook...
>   

I don't have any immediate plan to merge it myself, but I'm sure we can 
either add this back or otherwise work out how to implement it in the 
pvops kernel.

    J
