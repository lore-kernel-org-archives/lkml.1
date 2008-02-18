Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbYBRBzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbYBRBzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 20:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYBRBzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 20:55:46 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:44522 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbYBRBzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 20:55:45 -0500
Message-ID: <47B8E59F.5030004@kernel.org>
Date: Sun, 17 Feb 2008 17:55:43 -0800
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: charles.kirsch@internet.lu, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Gerald Combs <gerald@wireshark.org>,
       Gilbert Ramirez <gram@alumni.rice.edu>, Guy Harris <guy@alum.mit.edu>
Subject: Re: Possible problem in linux file posix capabilities
References: <20080217224851.GA9168@sergelap.austin.ibm.com> <47B8DD55.5070800@kernel.org> <20080218013943.GA17142@sergelap.austin.ibm.com>
In-Reply-To: <20080218013943.GA17142@sergelap.austin.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Serge E. Hallyn wrote:
| Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
| ---
|  security/commoncap.c |    2 +-
|  1 files changed, 1 insertions(+), 1 deletions(-)
|
| diff --git a/security/commoncap.c b/security/commoncap.c
| index 5aba826..bb0c095 100644
| --- a/security/commoncap.c
| +++ b/security/commoncap.c
| @@ -552,7 +552,7 @@ int cap_task_kill(struct task_struct *p, struct
siginfo *info,
|  	 * allowed.
|  	 * We must preserve legacy signal behavior in this case.
|  	 */
| -	if (p->euid == 0 && p->uid == current->uid)
| +	if (p->uid == current->uid)
|  		return 0;

Signed-off-by: Andrew G. Morgan <morgan@kernel.org>

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFHuOWf+bHCR3gb8jsRAr5jAKCQ9MTWW9VNKGbbhacygeI6G7kqTACcCMEP
hyz+xgh91wN3+6dcL72S85c=
=Fjd8
-----END PGP SIGNATURE-----
