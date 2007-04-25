Return-Path: <linux-kernel-owner+w=401wt.eu-S965528AbXDYMd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965528AbXDYMd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 08:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965552AbXDYMd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 08:33:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37531 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965528AbXDYMdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 08:33:55 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Fernando Luis =?utf-8?q?V=C3=A1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
Subject: Re: [PATCH 2/10] safe_apic_wait_icr_idle - x86_64
Date: Wed, 25 Apr 2007 14:26:14 +0200
User-Agent: KMail/1.9.6
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, horms@verge.net.au,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       vgoyal@in.ibm.com, mbligh@google.com, Keith Owens <kaos@ocs.com.au>,
       akpm@linux-foundation.org
References: <1177498984.16078.37.camel@sebastian.intellilink.co.jp> <1177499715.17974.12.camel@sebastian.intellilink.co.jp>
In-Reply-To: <1177499715.17974.12.camel@sebastian.intellilink.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704251426.14398.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>  static __inline__ void apic_wait_icr_idle(void)
>  {
> -	while (apic_read( APIC_ICR ) & APIC_ICR_BUSY)
> +	while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
>  		cpu_relax();
>  }
>  
> +static __inline__ unsigned int safe_apic_wait_icr_idle(void)

This should be probably not inline -- too large

-Andi
