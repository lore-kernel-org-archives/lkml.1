Return-Path: <linux-kernel-owner+w=401wt.eu-S1752229AbYJTPK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbYJTPK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 11:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbYJTPKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 11:10:18 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:1264 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYJTPKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 11:10:18 -0400
Date: Mon, 20 Oct 2008 17:07:31 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Ingo Molnar <mingo@elte.hu>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, vgoyal@redhat.com, hbabu@us.ibm.com,
       ebiederm@xmission.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, akpm@linux-foundation.org,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] x86, dumpstack: some more unification
Message-ID: <20081020150731.GA25999@mailshack.com>
References: <20081017210013.GD23591@hmsreliant.think-freely.org> <20081020121339.GE10594@elte.hu> <20081020134211.GA15574@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020134211.GA15574@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Mon, 20 Oct 2008 17:08:01 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.5; VDF: 7.0.7.63; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Neil,

Doing more unification of dumpstack is/was on my
TODO list, but it got sidetracked with some other
hobby projects.

I did unify oops_begin, oops_end, die and die_nmi,
and it seems to work. It needs more careful testing,
I think, but if someone (Neil?) wants to take a
look and validate the result...

Greetings,
    Alexander
