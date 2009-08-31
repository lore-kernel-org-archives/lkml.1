Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbZHaRoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbZHaRoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 13:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbZHaRoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 13:44:32 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:62451 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbZHaRob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 13:44:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAPqom0qrR7PD/2dsb2JhbADCAohBAY58BYQa
X-IronPort-AV: E=Sophos;i="4.44,306,1249257600"; 
   d="scan'208";a="200353614"
From: Roland Dreier <rdreier@cisco.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Rik van Riel <riel@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, raz ben yehuda <raziebe@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       peterz@infradead.org, maximlevitsky@gmail.com, efault@gmx.de,
       wiseman@macs.biu.ac.il, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
References: <1251282598.3514.20.camel@raz>
	<alpine.DEB.1.10.0908260943090.9924@gentwo.org>
	<1251297910.1791.22.camel@maxim-laptop> <1251322663.3882.48.camel@raz>
	<4A96B997.1070001@nortel.com>
	<alpine.DEB.1.10.0908271257270.17470@gentwo.org>
	<alpine.LFD.2.00.0908272242500.2888@localhost.localdomain>
	<4A97071F.5070804@novell.com> <4A973DAE.4020508@redhat.com>
	<4A975025.8030500@novell.com> <4A975CC4.1090208@novell.com>
	<alpine.LFD.2.00.0908281218560.2888@localhost.localdomain>
	<alpine.DEB.1.10.0908281446520.7317@gentwo.org>
	<alpine.LFD.2.00.0908282100040.19335@localhost.localdomain>
	<alpine.DEB.1.10.0908281551450.17784@gentwo.org>
	<alpine.LFD.2.00.0908282158100.19335@localhost.localdomain>
	<alpine.DEB.1.10.0908281619520.15573@gentwo.org>
	<alpine.LFD.2.00.0908282231260.19335@localhost.localdomain>
	<alpine.DEB.1.10.0908311517410.26046@V090114053VZO-1>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 31 Aug 2009 10:44:31 -0700
In-Reply-To: <alpine.DEB.1.10.0908311517410.26046@V090114053VZO-1> (Christoph
	Lameter's message of "Mon, 31 Aug 2009 15:19:15 -0400 (EDT)")
Message-ID: <adavdk3q3nk.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 31 Aug 2009 17:44:31.0646 (UTC) FILETIME=[B2167BE0:01CA2A62]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Some devices now have per cpu threads. See f.e. Mellanox IB drivers. Maybe
 > there is a way to restrict that.

AFAIK the Mellanox drivers just create a single-threaded workqueue.

 - R.
