Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbZJKREv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbZJKREv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 13:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756171AbZJKREv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 13:04:51 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:49968 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051AbZJKREu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 13:04:50 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAFat0UqrR7Hu/2dsb2JhbAC+D5ZahC0E
X-IronPort-AV: E=Sophos;i="4.44,542,1249257600"; 
   d="scan'208";a="406800709"
From: Roland Dreier <rdreier@cisco.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linuxtronix.de,
       hpa@zytor.com
Subject: Re: [PATCH] x86: Relegate CONFIG_PAT to EMBEDDED
References: <20091011084311.0ab3c3ea@infradead.org>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 11 Oct 2009 10:04:10 -0700
In-Reply-To: <20091011084311.0ab3c3ea@infradead.org> (Arjan van de Ven's
	message of "Sun, 11 Oct 2009 08:43:11 -0700")
Message-ID: <adaiqelj20l.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Oct 2009 17:04:11.0077 (UTC) FILETIME=[DA40B750:01CA4A94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes sense, but given that X86_PAT depends on MTRR

 config X86_PAT
 	bool
-	prompt "x86 PAT support"
+	default y
+	prompt "x86 PAT support" if EMBEDDED
 	depends on MTRR

should we give the same treatment to the MTRR option too?  (As far as I
can tell, MTRR defaults to n in the current Kconfig too)

 - R.
