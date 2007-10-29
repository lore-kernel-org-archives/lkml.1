Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbXJ2Xds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbXJ2Xds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbXJ2Xdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:33:40 -0400
Received: from gw.goop.org ([64.81.55.164]:37514 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbXJ2Xdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:33:39 -0400
Message-ID: <47266DCE.1070309@goop.org>
Date: Mon, 29 Oct 2007 16:33:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Zachary Amsden <zach@vmware.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Glauber de Oliveira Costa <glauber@t60.localdomain>,
       Dan Hecht <dhecht@vmware.com>, Garrett Smith <garrett@vmware.com>
Subject: Re: [PATCH] raise tsc clocksource rating
References: <11936994092607-git-send-email-gcosta@redhat.com> <1193697734.9793.86.camel@bodhitayantram.eng.vmware.com> <20071029224852.GA27547@elte.hu> <47266431.1010500@goop.org> <20071029225528.GA31293@elte.hu> <47266A00.4040408@goop.org> <20071029232140.GA10518@elte.hu>
In-Reply-To: <20071029232140.GA10518@elte.hu>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i dont remember us having discussed this before, ever. If there's any 
> "fight" about monotonicity and SMP then it would be a pretty onesided 
> affair, with you being beaten up seriously ;-)
>   

This is part of Xen's ABI, so it isn't easily changed.  You're right
that getting monotonicity is a pretty ugly affair of doing something
like "if (now < previous_return) return ++previous_return;", but its
better than using the tsc.

(Last time around, it was "Xen can't use the tsc because it can't ever
be used as a stable timebase" - though I don't think that was you
specifically.)

    J
