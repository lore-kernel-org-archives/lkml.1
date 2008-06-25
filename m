Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbYFYS4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbYFYS4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 14:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758527AbYFYSz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 14:55:57 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:50493 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758052AbYFYSz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 14:55:56 -0400
X-Greylist: delayed 606 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jun 2008 14:55:56 EDT
X-IronPort-AV: E=Sophos;i="4.27,703,1204502400"; 
   d="scan'208";a="758412"
User-Agent: Microsoft-Entourage/11.4.0.080122
Date: Wed, 25 Jun 2008 19:45:36 +0100
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for
 64-bit Xen support
From: Keir Fraser <keir.fraser@eu.citrix.com>
To: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>
CC: Mark McLoughlin <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Stephen Tweedie <sct@redhat.com>
Message-ID: <C48850E0.231A8%keir.fraser@eu.citrix.com>
Thread-Topic: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork
 for 64-bit Xen support
Thread-Index: AcjW86fC5gcDXELmEd2ISwAX8io7RQ==
In-Reply-To: <87skv1r8ln.fsf@basil.nowhere.org>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2008 18:45:45.0007 (UTC) FILETIME=[AD20E3F0:01C8D6F3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/6/08 13:40, "Andi Kleen" <andi@firstfloor.org> wrote:

>> to 0xffff880000000000.  I have no general justification for this: th
> 
> This will significantly decrease the maximum amount of physical
> memory supported by Linux longer term.

What does Linux expect to scale up to? Reserving 16 PML4 entries leaves the
kernel with 120TB of available 'negative' address space. Should be plenty, I
would think.

 -- Keir


