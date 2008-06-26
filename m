Return-Path: <linux-kernel-owner+w=401wt.eu-S1756934AbYFZIqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbYFZIqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbYFZIqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:46:38 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:60033 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbYFZIqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:46:37 -0400
Message-ID: <4863576B.7020408@kernel.org>
Date: Thu, 26 Jun 2008 01:46:35 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: dhowells@redhat.com, serue@us.ibm.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: [PATCH 0/4]: security: filesystem capabilities (was Re: [PATCH] capabilities:
 refactor kernel code + bugfix)
References: <485BCEEB.30105@kernel.org> <20080625163035.b409d693.akpm@linux-foundation.org>
In-Reply-To: <20080625163035.b409d693.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew,

Configuring filesystem capabilities is still tagged experimental, and
the effect of the "security fix" part of this change is conditional on
filesystem capabilities being configured. This late in the rc cycle, I'm
not convinced that the risk of this bugfix isn't greater than the benefit.

If you disagree, there is another "security" problem with filesystem
capabilities and strace, and I've been exploring the fix. This is also
the last fix I think we need before we can remove the experimental
attribute on filesystem capabilities.

As such, I'll follow this up with four patches. The first two are
bugfixes (affecting kernels configured with filesystem support); the
third is the refactoring; and the fourth removes the experimental tag on
filesystem capability support.

Cheers

Andrew

Andrew Morton wrote:
| On Fri, 20 Jun 2008 08:38:19 -0700
| "Andrew G. Morgan" <morgan@kernel.org> wrote:
|
|> From 8a2bffcb5363295ea43ef42c84c121a8e8c7ffa0 Mon Sep 17 00:00:00 2001
|> From: Andrew G. Morgan <morgan@kernel.org>
|> Date: Fri, 20 Jun 2008 08:16:06 -0700
|> Subject: [PATCH] Refactor filesystem capability support in main kernel.
|>
[...]
| This is one helluva large (security!) patch for so late in -rc.
|
| Could we please split out the bugfix for 2.6.26 (is it needed in 2.6.25
| too?) and hold the refactoring back for 2.6.27?
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFIY1dr+bHCR3gb8jsRAsUDAJsGSGgj7TVq29CoTIOff3p1xkHYYwCfWFQ9
Qm4ZQthlkNikLDoMuhalBx4=
=8NT4
-----END PGP SIGNATURE-----
