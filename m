Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbXJ2XRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbXJ2XRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbXJ2XRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:17:24 -0400
Received: from gw.goop.org ([64.81.55.164]:36401 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728AbXJ2XRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:17:23 -0400
Message-ID: <47266A00.4040408@goop.org>
Date: Mon, 29 Oct 2007 16:17:20 -0700
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
References: <11936994092607-git-send-email-gcosta@redhat.com> <1193697734.9793.86.camel@bodhitayantram.eng.vmware.com> <20071029224852.GA27547@elte.hu> <47266431.1010500@goop.org> <20071029225528.GA31293@elte.hu>
In-Reply-To: <20071029225528.GA31293@elte.hu>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> that's totally broken then. You cannot create an SMP-safe monotonic 
> clocksource via interpolation - native does not do it either. Good thing 
> this problem got exposed, it needs to be fixed.
>   

Sigh, I don't really want to have this fight again.

I don't really see what point there is in raising the tsc's rating (why
is 300 insufficient again?), but regardless of the value, the Xen
clocksource rating needs to be higher.

    J
