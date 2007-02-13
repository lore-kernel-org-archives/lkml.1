Return-Path: <linux-kernel-owner+w=401wt.eu-S932371AbXBMNf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371AbXBMNf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 08:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932428AbXBMNf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 08:35:56 -0500
Received: from hax.kala.ee ([194.126.124.39]:41316 "HELO hax.kala.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932371AbXBMNfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 08:35:55 -0500
From: Hasso Tepper <hasso@estpak.ee>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: /proc/sys/net/ipv[46]/conf/ issue unsolved
Date: Tue, 13 Feb 2007 15:29:04 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
Organization: Elion Enterprises Ltd.
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200702131529.04708.hasso@estpak.ee>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is long standing issue in kernel which makes using /etc/sysctl.conf
useless for boottime configuration of specific interface properties and
breaks probably any software relying on unconditional existence of the
conf trees like it was in previous kernels (I alone have written several
pieces of such software). It's broken AFAIK from 2.6.15. There has been
several notes about issue in the list, but issue haven't got any (at least
efficient) attention from developers.

The current behaviour bites users in many ways and breaks several use cases.
I asked several times in the past "what I should do now?" question, but
got no clear answer.

References:
http://marc.theaimsgroup.com/?l=linux-netdev&m=115685059625467&w=2
http://marc.theaimsgroup.com/?l=linux-netdev&m=115690828822486&w=2
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=169809

Is there any chance this will be fixed or at least clear position is
taken by developers? Breaking userspace applications is declared nonono
several times in the past ... I'm not even against breaking it if there
is _very_ good reason to do it. Ok, but I want to know how userspace is
meant to behave now. I can't continue using crappy workarounds.


regards,

-- 
Hasso Tepper
