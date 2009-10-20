Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbZJTUfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbZJTUfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 16:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbZJTUfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 16:35:19 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:58623 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbZJTUfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 16:35:18 -0400
From: Thomas Schlichter <thomas.schlichter@web.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not available
Date: Tue, 20 Oct 2009 22:35:12 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.28.10-bigboss; KDE/4.3.2; i686; ; )
Cc: Jan Beulich <JBeulich@novell.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, arjan@linux.intel.com,
       dri-devel@lists.sourceforge.net, hancockrwd@gmail.com, hmh@hmh.eng.br,
       hpa@zytor.com, jbarnes@virtuousgeek.org, jeremy.fitzhardinge@citrix.com,
       linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
       thellstrom@vmware.com, tj@kernel.org, venkatesh.pallipadi@intel.com,
       x86@kernel.org, yinghai@kernel.org
References: <1392906098@web.de> <20091019153134.GA18198@elte.hu>
In-Reply-To: <20091019153134.GA18198@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910202235.12277.thomas.schlichter@web.de>
X-Provags-ID: V01U2FsdGVkX1/r+L9xvgFicUriLvHhk1ftoFdr2YSYU5xoEatw
	TDxf1HZI6jYSpHnxBazugliZZIkr1HmXFaKu6pV/VfzA+MSOIJ
	4EjO8p6XfNKoSD90fJyQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Thomas Schlichter <thomas.schlichter@web.de> wrote:
> > > or Perhaps just try to add mtrr only for the pci mmap case like the
> > > 4th patch in this series..
> >
> > I'd prefer this! ;-)
> 
> Hm, we could perhaps do that - but i think we should only do that on
> systems that have PAT disabled.

The patch I sent should do exactly that.

> Which brings up the question of how to properly QA such a narrow segment
> of the market. Maybe disabling CONFIG_X86_PAT should enable that logic
> too.

When CONFIG_X86_PAT is disabled, pat_enabled is 0, and thus my new code should 
be active. Or do I miss something?

What do you think about the latest version of my patch series I just sent?

Kind regards,
  Thomas
