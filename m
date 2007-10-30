Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbXJ3L7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbXJ3L7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 07:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbXJ3L6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 07:58:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbXJ3L6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 07:58:54 -0400
Message-ID: <47271CAE.8000907@redhat.com>
Date: Tue, 30 Oct 2007 09:59:42 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070811)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, rusty@rustcorp.com.au, jeremy@goop.org,
       --cc@redhat.com, avi@quramnet.com, kvm-devel@lists.sourceforge.net,
       Glauber de Oliveira Costa <glauber@t60.localdomain>,
       Dan Hecht <dhecht@vmware.com>, Garrett Smith <garrett@vmware.com>
Subject: Re: [PATCH] raise tsc clocksource rating
References: <11936994092607-git-send-email-gcosta@redhat.com>	 <1193697734.9793.86.camel@bodhitayantram.eng.vmware.com>	 <20071029224852.GA27547@elte.hu> <1193698505.9793.90.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1193698505.9793.90.camel@bodhitayantram.eng.vmware.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Zachary Amsden escreveu:
> On Mon, 2007-10-29 at 23:48 +0100, Ingo Molnar wrote:
>> * Zachary Amsden <zach@vmware.com> wrote:
> 
>> if it's inaccurate why are you exposing it to the guest then? Native 
>> only uses the TSC if it's safe and accurate to do so.
> 
> Not every guest support paravirt, but for correctness, all guests
> require TSC, which must be exposed all the way up to userspace, no
> matter what the efficiency or accuracy may be.
> 
> Zach
> 
However, with such accuracy, it will fail the tsc clocksources tests. If
it passes, it'a good clocksource to use.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Remi - http://enigmail.mozdev.org

iD8DBQFHJxyujYI8LaFUWXMRAhI5AKCDl/O7iA3TdtpvElVg8NoSDVfKpgCeNvz3
ZEZDMxg8T7FA2R+5cgH/uKI=
=8qSH
-----END PGP SIGNATURE-----
