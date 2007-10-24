Return-Path: <linux-kernel-owner+w=401wt.eu-S1759562AbXJXRTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562AbXJXRTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbXJXRTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:19:10 -0400
Received: from lnx130.hrz.tu-darmstadt.de ([130.83.174.24]:40422 "EHLO
	lnx130.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753202AbXJXRTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:19:08 -0400
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2007 13:19:08 EDT
Date: Wed, 24 Oct 2007 19:11:29 +0200
From: Volker Sauer <vsauer@dvs.tu-darmstadt.de>
To: linux-kernel@vger.kernel.org
Cc: adi@postpi.com
Subject: D-Link DFE-580TX and snmpd problems, who's maintainer of
	sundance.c ?
Message-ID: <20071024171129.GA14255@volker-sauer.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
X-Mailer: Mutt http://www.mutt.org/
X-Editor: Vim http://www.vim.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
X-TUD-HRZ-MailScanner: Found to be clean
X-TUD-HRZ-MailScanner-SpamCheck: 
X-MailScanner-From: vsauer@dvs.tu-darmstadt.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

there already was a thread on this topic in summer but with no result:

http://groups.google.com/group/fa.linux.kernel/browse_thread/thread/4b433f881e3585b2/a36ccba40ef2e59d?hl=en&lnk=gst&q=Re%3A+D-Link+DFE-580TX+4+port+NIC+problems#a36ccba40ef2e59d

Adi tracked down, that the messages in the syslog (in my case appearing
exactly every 30 seconds), come from snmpd running on the same machine
calling SIOCDEVPRIVATE.

This behaviour still exists in 2.6.23.1

I'm neither a skilled C-programmer nor a kernel-expert, but looking at
drivers/net/sundance.c:1605 I see, that SIOCDEVPRIVATE does
nothing else then printing this debug message.

So the questions is: why? What is this good for?
And: can I remove it? I can not abandon snmpd and the messages spam my
syslog.
Or: do I have to patch snmpd?

Regards
Volker

-> Please CC: me, I'm not on the list <-

P.S.: there's no one in the MAINTAINERS file for sundance.c. Is someone
here who still cares about this driver?


--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHH3zBfjVOTV3V0OARAnhqAJwI42BY05Dyhi/dqA2UqI+vtYwJxgCgkGJQ
z58SSnHzJS3j/y52fqHbI5o=
=Y9JW
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
