Return-Path: <linux-kernel-owner+w=401wt.eu-S1161540AbXDYMd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161540AbXDYMd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 08:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965565AbXDYMd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 08:33:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:37532 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965552AbXDYMdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 08:33:55 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Fernando Luis =?iso-8859-15?q?V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
Subject: Re: [PATCH 10/10] Use safe_apic_wait_icr_idle in __send_IPI_dest_field - x86_64
Date: Wed, 25 Apr 2007 14:33:40 +0200
User-Agent: KMail/1.9.6
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, horms@verge.net.au,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       vgoyal@in.ibm.com, mbligh@google.com, Keith Owens <kaos@ocs.com.au>,
       akpm@linux-foundation.org
References: <1177498984.16078.37.camel@sebastian.intellilink.co.jp> <1177501872.17974.56.camel@sebastian.intellilink.co.jp>
In-Reply-To: <1177501872.17974.56.camel@sebastian.intellilink.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200704251433.40302.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 April 2007 13:51:12 Fernando Luis Vázquez Cao wrote:
> Use safe_apic_wait_icr_idle to check ICR idle bit if the vector is
> NMI_VECTOR to avoid potential hangups in the event of crash when kdump
> tries to stop the other CPUs.

But what happens then when this fails? Won't this give another hang?
Have you tested this?

I applied the patches for now.

-Andi
