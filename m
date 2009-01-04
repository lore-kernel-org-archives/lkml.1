Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbZADBre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbZADBre (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 20:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZADBrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 20:47:25 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:45501
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbZADBrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 20:47:24 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Sat, 3 Jan 2009 19:47:20 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Matthieu CASTET <matthieu.castet@parrot.com>,
       Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200901020207.30359.rob@landley.net> <20090103201059.GA4875@uranus.ravnborg.org> <495FCFA3.4030000@zytor.com>
In-Reply-To: <495FCFA3.4030000@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901031947.21179.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009 14:50:43 H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> > With respect to your three patches the plan is to:
> > - add the updated timeconst patch to kbuild-next
>
> If you add this, you take the responsibility for the breakages that will
> occur.  The reason his patch is "simpler" is because he removes the
> arbitrary-precision arithmetic, and simply hopes that the system
> utilities that he uses uses an integer size which happens to be big enough.

Actually once I _noticed_ that ADJ32 could overflow (none of the other values 
can), it was fairly easy to prevent it from doing so.  I added some comments 
analyzing the pathological case (HZ 1, assuming nobody's interested in 
HZ>1000000).

> 	-hpa

Rob
