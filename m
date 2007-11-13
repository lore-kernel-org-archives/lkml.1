Return-Path: <linux-kernel-owner+w=401wt.eu-S1758767AbXKMRXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767AbXKMRXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 12:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbXKMRXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 12:23:43 -0500
Received: from gw.goop.org ([64.81.55.164]:40799 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbXKMRXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 12:23:42 -0500
Message-ID: <4739DD2F.5060605@goop.org>
Date: Tue, 13 Nov 2007 09:21:51 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: Andi Kleen <ak@suse.de>, lguest@ozlabs.org, kiran@scalemp.com,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, chrisw@sous-sol.org,
       tglx@linutronix.de, anthony@codemonkey.ws, akpm@linux-foundation.org,
       mingo@elte.hu
Subject: Re: [PATCH 24/24] make vsmp a paravirt client
References: <11946338683305-git-send-email-gcosta@redhat.com>	<20071111180709.GG22277@bingen.suse.de>	<47398C4A.40806@redhat.com> <200711131333.41946.ak@suse.de> <47399DC8.7000504@redhat.com>
In-Reply-To: <47399DC8.7000504@redhat.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> the ifdef only exists because, as I said, the code itself will be always
> compiled in, to avoid an ifdef in setup_64.c. So it's just a taking it
> from here, putting it there issue. Kiran seem to prefer this way, but I
> don't really have a preference.

It would be better to have the ifdef in setup_64.c and just make the
compilation of vsmp_64.c depend on CONFIG_X86_VSMP.  If the ifdef really
rankles you could use a weak stub function somewhere, or define an
inline stub in vsmp.h.

    J
