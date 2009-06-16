Return-Path: <linux-kernel-owner+w=401wt.eu-S1764255AbZFPU54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764255AbZFPU54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760178AbZFPU5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:57:47 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:34460 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759919AbZFPU5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:57:46 -0400
Date: Tue, 16 Jun 2009 22:57:47 +0200
From: Andreas Mohr <andi@lisas.de>
To: Ed Tomlinson <edt@aei.ca>
Cc: Borislav Petkov <petkovbb@googlemail.com>, Peter Feuerer <peter@piie.net>,
       akpm@linux-foundation.org, Andreas Mohr <andi@lisas.de>,
       Len Brown <len.brown@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] Acer Aspire One fan control resume fix,
	improvements
Message-ID: <20090616205747.GA6356@rhlx01.hs-esslingen.de>
References: <20090604211103.4214303f.peter@piie.net> <cone.1245086149.988051.6046.1000@deskpiie> <20090616060107.GA4752@liondog.tnic> <200906160747.04094.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906160747.04094.edt@aei.ca>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 16, 2009 at 07:47:02AM -0400, Ed Tomlinson wrote:
> Please add this to the kernel now.  I have been using version of this on my wife's
> acer since I installed linux on it.  Its been doing its job as adverstised.  This is not
> a core feature - its a driver.  It works.  Why not add it?

Seconded. Better not wait 18 months this time.

This being said, I'm unfortunately _still_ experiencing the resume issue (unexpected fan
state) from time to time after resume. Really needs more investigation
to get that fixed somehow, eventually.

Also, the pre_suspend_kernelmode variable is superfluous indeed, as mentioned this
can be simplified.

Atom emergency shutdown works fine on my machine (blocked fan sometimes,
going tick-tick-tick on boot etc., nice way to test this BIOS feature ;),
thus given this extra protection I believe the driver can be committed as is
anyway, nevermind any remaining driver issues which _might_ perhaps
eventually still exist.

Andreas Mohr
