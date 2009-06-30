Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbZF3PBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbZF3PBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 11:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZF3PBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 11:01:34 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50272 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbZF3PBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 11:01:33 -0400
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <alpine.DEB.1.10.0906301030260.6124@gentwo.org>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
	 <5Hhc7UkUKEO.A.fNH.4kASKB@chimera> <4A48F114.1010702@lwfinger.net>
	 <alpine.DEB.2.00.0906291642520.17663@chino.kir.corp.google.com>
	 <84144f020906292355o7cf63f7ch47bd19961cf92da3@mail.gmail.com>
	 <alpine.DEB.1.10.0906301030260.6124@gentwo.org>
Date: Tue, 30 Jun 2009 18:01:35 +0300
Message-Id: <1246374095.8014.28.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-30 at 10:32 -0400, Christoph Lameter wrote:
> kmalloc-4096 causes problems in the long run and so do other caches that
> are of similar size. But it allows debugging to occur. Silently switching
> it off is something I am not comfortable with.

I suggested adding a

  printk(KERN_INFO ": debugging disabled for %s. Use slub_debug=a to "
                    "enable it blah blah blah\n");

Does that work for you?

			Pekka

