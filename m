Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbYGXMeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbYGXMeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbYGXMd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:33:56 -0400
Received: from mk-outboundfilter-6-a-2.mail.uk.tiscali.com ([212.74.114.16]:18605
	"EHLO mk-outboundfilter-6-a-2.mail.uk.tiscali.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbYGXMdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:33:55 -0400
X-Trace: 5949795/mk-outboundfilter-6.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EAFwTiEjDlSwG/2dsb2JhbACBWrAA
X-IronPort-AV: E=Sophos;i="4.31,246,1215385200"; 
   d="scan'208";a="5949795"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 22bb1be4d27... breaks hal (and NM)
Date: Thu, 24 Jul 2008 13:33:52 +0100
User-Agent: KMail/1.9.9
Cc: Peter Zijlstra <peterz@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       "John W. Linville" <linville@tuxdriver.com>,
       Jean Tourrilhes <jt@hpl.hp.com>, LKML <linux-kernel@vger.kernel.org>
References: <20080724115805.5466c217@mjolnir.drzeus.cx> <1216900631.7257.321.camel@twins> <20080724051113.fa14f7ec.akpm@linux-foundation.org>
In-Reply-To: <20080724051113.fa14f7ec.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807241333.52206.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2008 13:11:13 Andrew Morton wrote:
> : +	  Say Y if you have programs using it (we don't know of any).

Probably would have been less confusing if the Kconfig message actually lined 
up with the note about older HALs in feature-removal-schedule.txt. Saying "we 
don't know of any" seems inaccurate. This should really be something 
like "old HAL versions" or perhaps even better "HAL <= X.Y.Z".

I'm sure distributors will have the common sense to stop enabling the option 
in the future. In the mean time, removing the deceptive summary would 
hopefully avoid such bug reports.

-- 
Cheers,
Alistair.
