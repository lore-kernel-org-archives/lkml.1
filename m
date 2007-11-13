Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbXKMMwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbXKMMwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 07:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbXKMMv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 07:51:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbXKMMvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 07:51:55 -0500
Message-ID: <47399DC8.7000504@redhat.com>
Date: Tue, 13 Nov 2007 10:51:20 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070811)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, rusty@rustcorp.com.au,
       chrisw@sous-sol.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com, Steven Rostedt <rostedt@goodmis.org>,
       kiran@scalemp.com
Subject: Re: [PATCH 24/24] make vsmp a paravirt client
References: <11946338683305-git-send-email-gcosta@redhat.com> <20071111180709.GG22277@bingen.suse.de> <47398C4A.40806@redhat.com> <200711131333.41946.ak@suse.de>
In-Reply-To: <200711131333.41946.ak@suse.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andi Kleen escreveu:
>> The vsmp_64.c file is now compiled unconditionally, according to which
>> me and kiran agreed to. The detection code is always run, but will only
>> trigger when a suitable box is found. Accordingly, the paravirt structs
>> are only touched when PARAVIRT is on. Otherwise, we don't even have the
>> symbols.
> 
> That seems dumb. What good is it if it doesn't patch the interrupt code?

If vsmp is selected, PARAVIRT will be too, and the interrupt code will
be patched.
the vsmp option triggers a select statement.

the ifdef only exists because, as I said, the code itself will be always
compiled in, to avoid an ifdef in setup_64.c. So it's just a taking it
from here, putting it there issue. Kiran seem to prefer this way, but I
don't really have a preference.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Remi - http://enigmail.mozdev.org

iD8DBQFHOZ3IjYI8LaFUWXMRAjPkAJ0XosdyMcj1j4h6XW5dVaj95NH7cgCeIW5o
CGnBnZOTGz9DIu5D997bsZ4=
=BP57
-----END PGP SIGNATURE-----
