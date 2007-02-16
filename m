Return-Path: <linux-kernel-owner+w=401wt.eu-S1751916AbXBPKoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbXBPKoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 05:44:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbXBPKoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 05:44:07 -0500
Received: from 207.47.60.150.static.nextweb.net ([207.47.60.150]:18544 "EHLO
	webmail.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbXBPKoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 05:44:06 -0500
User-Agent: Microsoft-Entourage/11.2.5.060620
Date: Fri, 16 Feb 2007 10:44:02 +0000
Subject: Re: [Xen-devel] Re: [patch 14/21] Xen-paravirt: Add XEN config
 options and disable unsupported config options.
From: Keir Fraser <keir@xensource.com>
To: Zachary Amsden <zach@vmware.com>, Keir Fraser <keir@xensource.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, <xen-devel@lists.xensource.com>,
       Andi Kleen <ak@muc.de>, Dan Hecht <dhecht@vmware.com>,
       <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Ian Pratt <ian.pratt@xensource.com>, <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Hand <steven.hand@cl.cam.ac.uk>
Message-ID: <C1FB3B72.98E5%keir@xensource.com>
Thread-Topic: [Xen-devel] Re: [patch 14/21] Xen-paravirt: Add XEN config
 options and disable unsupported config options.
Thread-Index: AcdRt18dnW0/Pr2qEduvqQAX8io7RQ==
In-Reply-To: <45D58531.4010808@vmware.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/2/07 10:19, "Zachary Amsden" <zach@vmware.com> wrote:

> Doesn't stop_machine_run already take care of getting you out of all
> kernel threads?  So you can only be sleeping, not preempted, in which
> case, this might not be an issue?

It ensures that no (non-stopmachine) threads are running on any of the other
CPUs, but it doesn't guarantee that all threads are at any form of quiescent
point. They can certainly have private references to machine addresses.

Otherwise, what would be the point of the process freezer? :-)

 -- Keir

