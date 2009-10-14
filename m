Return-Path: <linux-kernel-owner+w=401wt.eu-S1761918AbZJNPJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761918AbZJNPJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761906AbZJNPJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:09:45 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:37444 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761909AbZJNPJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:09:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=un/O+xzrRHIfGm02fU3NRh42pzyZ3+YOhZy8qWYg1X2rIVGCl873zGBfuOmV+bsCKX
         sSFeuME1IOSt1x//KJi1cQWsehFw0aiey7jC3/u3fomGqEnZFbzBXWbHbDUh2ukjljfl
         rQqSS7sHVawVDkxYBT1+Vx0z4RNaFjDhbXHfU=
Date: Wed, 14 Oct 2009 19:09:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, yinghai@kernel.org, macro@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] x86,apic: limit apic dumping, introduce show_lapic
	setup option
Message-ID: <20091014150904.GA5259@lenovo>
References: <20091013200702.019870576@openvz.org> <20091013201022.926793122@openvz.org> <20091014071217.GL784@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014071217.GL784@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Wed, Oct 14, 2009 at 09:12:17AM +0200]
| 
...
| Note: new __setup() functions need an entry in 
| Documentation/kernel-parameters.txt as well.
| 
| 	Ingo
| 

Here is it.

	-- Cyrill
---
x86,apic: explain show_lapic in kernel parameters list

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 Documentation/kernel-parameters.txt |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6.git/Documentation/kernel-parameters.txt
=====================================================================
--- linux-2.6.git.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.git/Documentation/kernel-parameters.txt
@@ -345,6 +345,15 @@ and is between 256 and 4096 characters. 
 			Change the amount of debugging information output
 			when initialising the APIC and IO-APIC components.
 
+	show_lapic=	[APIC,X86] Advanced Programmable Interrupt Controller
+			Limit apic dumping. The parameter defines the maximal
+			number of local apics being dumped. Also it is possible
+			to set it to "all" by meaning -- no limit here.
+			Format: { 1 (default) | 2 | ... | all }.
+			The parameter valid if only apic=debug or
+			apic=verbose is specified.
+			Example: apic=debug show_lapic=all
+
 	apm=		[APM] Advanced Power Management
 			See header of arch/x86/kernel/apm_32.c.
 
