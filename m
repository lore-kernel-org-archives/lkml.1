Return-Path: <linux-kernel-owner+w=401wt.eu-S1756371AbXJ3MNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbXJ3MNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 08:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbXJ3MNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 08:13:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552AbXJ3MNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 08:13:24 -0400
Message-ID: <47272007.8000108@redhat.com>
Date: Tue, 30 Oct 2007 10:13:59 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070811)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, --cc@redhat.com,
       avi@quramnet.com, kvm-devel@lists.sourceforge.net,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] raise tsc clocksource rating
References: <11936994092607-git-send-email-gcosta@redhat.com> <alpine.LFD.0.9999.0710292315280.3186@localhost.localdomain> <200710301339.23628.rusty@rustcorp.com.au> <20071030073736.GA21843@elte.hu>
In-Reply-To: <20071030073736.GA21843@elte.hu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ingo Molnar escreveu:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> and just in case it's not obvious: i am not arguing for the inclusion of 
> the patch, i'm just pointing out the plain fact that in the case where 
> the TSC _is_ reliable, 5 different clocksource drivers for has obvious 
> disadvantages. Anyone arguing against that simple point needs his head 
> examined :) Once we can pass around calibration information from the 
> host to the guest (which we dont do at the moment) there will be reason 
> not to use the native clocksource driver in the guest.
If you sustain that we cannot have a reliable synchronization test
mechanism, neither do I. All this is based in the assumption that a bad
tsc will fail such tests.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Remi - http://enigmail.mozdev.org

iD8DBQFHJyAHjYI8LaFUWXMRAtYoAJ9l5kNodRLfTsNHDvyioufM7SQzTACfarEy
XXq3sDq9uxZ/72hhA46YmgM=
=DwN/
-----END PGP SIGNATURE-----
