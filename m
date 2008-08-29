Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbYH2Ahv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbYH2Ahv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 20:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbYH2Ahn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 20:37:43 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:48417 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbYH2Ahm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 20:37:42 -0400
Message-ID: <48B744AE.5040606@kernel.org>
Date: Thu, 28 Aug 2008 17:37:02 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Serge Hallyn <serue@us.ibm.com>
CC: linux-kernel@vger.kernel.org, dhowells@redhat.com, agruen@suse.de
Subject: Re: [PATCH 2/2] file capabilities: turn on by default
References: <> <f79cd5c96d2996b984fdfe1c7d8300975f55e8e6.1219951973.git.serue@us.ibm.com> <fe7784a0710a8fef0ac2e4f39589dff6f8293ad0.1219951973.git.serue@us.ibm.com>
In-Reply-To: <fe7784a0710a8fef0ac2e4f39589dff6f8293ad0.1219951973.git.serue@us.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Acked-by: Andrew G. Morgan <morgan@kernel.org>

Cheers

Andrew

Serge Hallyn wrote:
| Now that file capabilities can be turned off at boot, go ahead
| and compile them into the kernel by default by making
| CONFIG_SECURITY_FILE_CAPABILITIES=y the default.
|
| Note that the boot flag no_file_caps must be specified to turn
| file capabilities off, as by default they are on.  So the
| default behavior is in fact changed.
|
| Signed-off-by: Serge Hallyn <serue@us.ibm.com>
| ---
|  security/Kconfig |    7 +++++--
|  1 files changed, 5 insertions(+), 2 deletions(-)
|
| diff --git a/security/Kconfig b/security/Kconfig
| index 5592939..6fbb233 100644
| --- a/security/Kconfig
| +++ b/security/Kconfig
| @@ -75,12 +75,15 @@ config SECURITY_NETWORK_XFRM
|
|  config SECURITY_FILE_CAPABILITIES
|  	bool "File POSIX Capabilities"
| -	default n
| +	default y
|  	help
|  	  This enables filesystem capabilities, allowing you to give
|  	  binaries a subset of root's powers without using setuid 0.
|
| -	  If in doubt, answer N.
| +	  You can still boot with the no_file_caps option to disable
| +	  file capabilities.
| +
| +	  If in doubt, answer Y.
|
|  config SECURITY_ROOTPLUG
|  	bool "Root Plug Support"
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIt0Sp+bHCR3gb8jsRAmQuAKDXiLp/7hZ++JDxv1rL1kIVqS/YtgCeJIMk
zmPFh8NjFrUnElWyeF5R/Jo=
=AK55
-----END PGP SIGNATURE-----
