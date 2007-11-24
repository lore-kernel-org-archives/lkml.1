Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbXKXDZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbXKXDZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 22:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbXKXDZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 22:25:30 -0500
Received: from twinlark.arctic.org ([207.29.250.54]:55834 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbXKXDZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 22:25:29 -0500
Message-ID: <4747999E.4020201@kernel.org>
Date: Fri, 23 Nov 2007 19:25:18 -0800
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: casey@schaufler-ca.com
CC: Stephen Smalley <sds@tycho.nsa.gov>, "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org, darwish.07@gmail.com,
       jmorris@namei.org, method@manicmethod.com, paul.moore@hp.com,
       LSM List <linux-security-module@vger.kernel.org>
Subject: Re: + smack-version-11c-simplified-mandatory-access-control-kernel.patch
 added to -mm tree
References: <739077.85064.qm@web36613.mail.mud.yahoo.com>
In-Reply-To: <739077.85064.qm@web36613.mail.mud.yahoo.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Casey Schaufler wrote:
> In the end we can call it CAP_LATE_FOR_DINNER if that's the only way
> I can move forward. CAP_MAC_OVERRIDE is the obvious partner to
> CAP_DAC_OVERRIDE, so that's still my preference. CAP_SMACK_OVERRIDE
> unnecessarily ties it to one LSM, and in spite of what some people
> still seem to think, I see more LSMs in the pipeline.

I'd personally not like to see SMACK appear in a capability name. No
offense Casey, but SMACK may be displaced with YAMAC (*) someday, and
I'd hate to have wasted a capability on it. Using CAP_MAC_OVERRIDE makes
sense to me - even if its not (yet/ever) honored by all MAC LSMs.

I do have a question about whether one capability is sufficient in
general for MAC. Looking at the:

  http://wt.xpilot.org/publications/posix.1e/download.html

last draft, there are no less than 5 capabilities (p173) allocated for
MAC. Presumably there was a good reason for 5 and not 1 back then -
could you summarize what is different now?

Thanks

Andrew

(*) yet-another example of yet-another

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHR5mc+bHCR3gb8jsRAlB9AJsHPi1+fFp1ONKJCMFDpLS1lYG4AwCfYxMX
8aaU+sOBNHU01uldtrJ8cEI=
=/USy
-----END PGP SIGNATURE-----
