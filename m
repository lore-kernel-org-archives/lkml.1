Return-Path: <linux-kernel-owner+w=401wt.eu-S1758070AbZDUVMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbZDUVMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 17:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755674AbZDUVL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 17:11:58 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:43673 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379AbZDUVL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 17:11:57 -0400
X-IronPort-AV: E=Sophos;i="4.40,226,1238976000"; 
   d="scan'208";a="157363809"
From: Roland Dreier <rdreier@cisco.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hitoshi Mitake <h.mitake@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: arch/x86/Kconfig selects invalid HAVE_READQ, HAVE_WRITEQ vars
References: <alpine.LFD.2.00.0904191543530.11789@localhost.localdomain>
	<adaab6c1h7c.fsf@cisco.com> <20090419214602.GA21527@elte.hu>
	<adaws9gywkd.fsf@cisco.com> <49EBCDC0.1020001@zytor.com>
	<20090420105304.GC6670@elte.hu>
	<a6b9f31a0904200747x7e28a4e3if0be4fc0d87241c9@mail.gmail.com>
	<20090420160332.GB9689@elte.hu>
	<a6b9f31a0904210133m29e68580w1fb7a8e6159b65d6@mail.gmail.com>
	<49EDE9E9.8090905@zytor.com> <adamyaavst5.fsf@cisco.com>
	<49EE0013.6010008@zytor.com> <adaab69x6nd.fsf@cisco.com>
	<49EE19E0.8040405@zytor.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 21 Apr 2009 14:11:54 -0700
In-Reply-To: <49EE19E0.8040405@zytor.com> (H. Peter Anvin's message of "Tue,
	21 Apr 2009 12:09:20 -0700")
Message-ID: <adaocupvhid.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Apr 2009 21:11:56.0737 (UTC) FILETIME=[CD69AB10:01C9C2C5]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Do you really expect driver authors to type writeq_nonatomic() for
 > every register reference?

No -- that's why I didn't even bring it up at first and why I consider
it ugly.

 > I think an #include at the top is one thing, but something that
 > heavyweight for each call site really isn't going to fly.

Yeah, I guess that could work, although I do worry that debugging the
wrong choice of #include might be a pain (mysterious symptoms on 32-bit
architectures caused by the name of an include file would be hard to
track).

To be honest I think the status quo ante was not really that bad.

 - R.
