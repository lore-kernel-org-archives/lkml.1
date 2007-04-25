Return-Path: <linux-kernel-owner+w=401wt.eu-S2992742AbXDYNRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992742AbXDYNRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 09:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992754AbXDYNRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 09:17:00 -0400
Received: from mx1.suse.de ([195.135.220.2]:33371 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992742AbXDYNQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 09:16:59 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Keith Owens <kaos@ocs.com.au>
Subject: Re: [PATCH 1/10] safe_apic_wait_icr_idle - i386
Date: Wed, 25 Apr 2007 15:16:56 +0200
User-Agent: KMail/1.9.6
Cc: Fernando Luis =?iso-8859-1?q?V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       "Eric W. Biederman" <ebiederm@xmission.com>, horms@verge.net.au,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       vgoyal@in.ibm.com, mbligh@google.com, akpm@linux-foundation.org
References: <15716.1177505701@ocs3.ocs.com.au>
In-Reply-To: <15716.1177505701@ocs3.ocs.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704251516.56333.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> 	do {
> 		send_status = apic_read(APIC_ICR) & APIC_ICR_BUSY;
> 		if (send_status)

Surely if (!send_status)

> 			break;
> 		udelay(100);
> 	} while (timeout++ < 1000);

-Andi


