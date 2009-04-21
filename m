Return-Path: <linux-kernel-owner+w=401wt.eu-S1752433AbZDUGfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbZDUGfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 02:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbZDUGfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 02:35:04 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:42650 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZDUGfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 02:35:01 -0400
Date: Tue, 21 Apr 2009 15:29:53 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Luck, Tony" <tony.luck@intel.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, randy.dunlap_ocs10g@oracle.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: linux-next ia64 build problems in slqb
Message-ID: <20090421062952.GA15167@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	"Luck, Tony" <tony.luck@intel.com>, Nick Piggin <npiggin@suse.de>,
	linux-kernel@vger.kernel.org, randy.dunlap_ocs10g@oracle.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux-foundation.org>
References: <49ecf25e2378234eed@agluck-desktop.sc.intel.com> <84144f020904202251n616f188k80c6ce7d974d8b00@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020904202251n616f188k80c6ce7d974d8b00@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 08:51:47AM +0300, Pekka Enberg wrote:
> Hi Tony,
> 
> On Tue, Apr 21, 2009 at 1:08 AM, Luck, Tony <tony.luck@intel.com> wrote:
> > The ia64 "allnoconfig" build ends up with the (possibly dubious) combination
> > of .config options:
> >
> > ? ? ? ?CONFIG_SMP=n
> > ? ? ? ?CONFIG_NUMA=y
> 
> Yeah, I don't think the combination makes much sense and x86 doesn't
> allow it. Can we fix that in ia64 Kconfig? That said, this seems to
> come up with every architecture except x86, so if someone is kind
> enough to send me a tested fix for slqb, I'll just go ahead and apply
> it.
> 
This configuration is used on SH quite regularly, so if SLQB breaks, then
that is a regression.
