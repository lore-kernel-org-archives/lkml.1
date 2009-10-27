Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbZJ0LbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbZJ0LbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 07:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbZJ0LbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 07:31:05 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:41334 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbZJ0LbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 07:31:05 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: pradeep hettiarachchi <pradeepmh@wayne.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Frequency Scaling on Intel Core 2 Duo Processors
In-Reply-To: Your message of "Mon, 26 Oct 2009 11:06:23 EDT."
             <8fe204b0910260806l10896f9foc0568dd0b8f4b6ca@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <8fe204b0910260806l10896f9foc0568dd0b8f4b6ca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1256643068_9496P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Oct 2009 07:31:08 -0400
Message-ID: <43501.1256643068@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.34.98 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020205.4AE6D9FC.0295,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1256643068_9496P
Content-Type: text/plain; charset=us-ascii

On Mon, 26 Oct 2009 11:06:23 EDT, pradeep hettiarachchi said:
> Hi,
> 
> I am working on a research in real-time systems. If I want to change
> the frequency of the system as rapidly as possible, what is the best
> method ? At the moment I write MSR_IA32_PERF_CTL, MSR directly with
> the pre-found(calculated, encoded) values** for different frequencies.
> I found the entire transition (latency) takes multiple milliseconds to
> complete; however, I want some faster method to change the CPU
> frequency.

You're going to have a hard time making it switch any faster than the value
listed in /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_transition_latency
though I admit I'm not awake enough yet to be sure what the units of that file
are...


--==_Exmh_1256643068_9496P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK5tn8cC3lWbTT17ARAikzAJ4wNRn1a+XOwNSp9f7qH+m4wHStiQCcCr5H
KvctzJn1cUtMmCcSnf2iPoM=
=kPfx
-----END PGP SIGNATURE-----

--==_Exmh_1256643068_9496P--

