Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbXL2VSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbXL2VSI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 16:18:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbXL2VR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 16:17:56 -0500
Received: from ns1.suse.de ([195.135.220.2]:54171 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbXL2VRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 16:17:55 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] x86: unify x86 Makefile(s)
Date: Sat, 29 Dec 2007 22:17:37 +0100
User-Agent: KMail/1.9.6
Cc: Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <20071228212341.GA6939@uranus.ravnborg.org> <200712291924.52077.ak@suse.de> <20071229185842.GA20099@uranus.ravnborg.org>
In-Reply-To: <20071229185842.GA20099@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712292217.37474.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Until we are on par with stack usage I recommend to keep
> -fno-unit-at-a-time disabled for gcc less than 4.00 as
> suggested by Adrian (as is what we have today).

Again the correct fix is to add "noinline" to the functions that are getting
inlined here in 3.4 but not 4+.

-Andi



