Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbYFUIFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbYFUIFi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 04:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYFUIFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 04:05:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:21172 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbYFUIFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 04:05:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tuj2sO3+Iuud6r+NILTnBMNecB1G1jttONgRG4bhlF4Qoy0omhx/O5wks+M1MteU/+
         48eAn16sMXlX53e9sz8amH1nQBkE3oFlfnScGeCOtfDjJLd/agpcixct92h5RwDsd9U4
         Fk1xsDMYZOIxX0P/Wvz5y2xRFJ1KHFYZVCbsY=
Date: Sat, 21 Jun 2008 12:04:40 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: nmi_watchdog suspicious
Message-ID: <20080621080440.GA7056@cvg>
References: <20080610185759.GA7353@cvg> <Pine.LNX.4.55.0806160040270.11995@cliff.in.clinika.pl> <20080616170000.GC7273@cvg> <Pine.LNX.4.55.0806161819500.20218@cliff.in.clinika.pl> <20080617155120.GA9440@cvg> <Pine.LNX.4.55.0806181654450.4857@cliff.in.clinika.pl> <20080618163905.GB7117@cvg> <Pine.LNX.4.55.0806181749050.4857@cliff.in.clinika.pl> <20080618172316.GA10431@cvg> <Pine.LNX.4.55.0806210250210.19614@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0806210250210.19614@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Sat, Jun 21, 2008 at 02:54:38AM +0100]
| On Wed, 18 Jun 2008, Cyrill Gorcunov wrote:
| 
| > If you mean the case we get NMI physical line assetred while configuring APIC
| > (ie nmi watchdog is not properly configured yet) then I wonder why we has
| > this checking at all...
| 
|  Hmm, I am not sure what you mean -- nmi_watchdog_tick() can be called
| potentially at any time, and you can receive NMIs from sources other than
| the watchdog; the latters would set bits in the Port B at 0x61 in most
| cases though.  Anyway using a separate variable such as
| "nmi_watchdog_active" would be cleaner.
| 
|   Maciej
| 

ok, thanks Maciej, i'll take a look on this.

		- Cyrill -
