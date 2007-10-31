Return-Path: <linux-kernel-owner+w=401wt.eu-S1759596AbXJaQsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596AbXJaQsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbXJaQr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:47:56 -0400
Received: from ns.suse.de ([195.135.220.2]:60074 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060AbXJaQrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:47:55 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] Use 64bit timer values while calibrating BogoMips
Date: Wed, 31 Oct 2007 17:47:51 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200710311652.16776.ak@suse.de> <20071031093100.3a1542b0@laptopd505.fenrus.org>
In-Reply-To: <20071031093100.3a1542b0@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710311747.51441.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> bogomips tends to not be used for that nowadays

udelay certainly uses loops_per_jiffy (= BogoMips), even
though it can be scaled.

-Andi
