Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbXL2SZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbXL2SZH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 13:25:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbXL2SY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 13:24:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44484 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879AbXL2SY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 13:24:56 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] x86: unify x86 Makefile(s)
Date: Sat, 29 Dec 2007 19:24:51 +0100
User-Agent: KMail/1.9.6
Cc: Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <20071228212341.GA6939@uranus.ravnborg.org> <20071229125412.GE27360@does.not.exist> <20071229182241.GA19919@uranus.ravnborg.org>
In-Reply-To: <20071229182241.GA19919@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712291924.52077.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> This is the version that should exhibit the behaviour with increased text size.

The issue was not text size (u-a-a-t generally decreases that) but maximum stack usage.
You need to check make checkstack output.

-Andi
