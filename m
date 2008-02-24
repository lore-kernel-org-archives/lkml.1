Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbYBXNTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbYBXNTd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 08:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbYBXNTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 08:19:22 -0500
Received: from rhineheart.priorweb.be ([213.193.229.215]:33350 "HELO
	rhineheart.priorweb.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752440AbYBXNTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 08:19:21 -0500
Date: Sun, 24 Feb 2008 13:12:34 +0000
From: Kristof Provost <Kristof@sigsegv.be>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep warnings in ipv6
Message-ID: <20080224131234.GA4973@nereid>
References: <Pine.LNX.4.64.0802241307310.15321@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; x-action=pgp-signed
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802241307310.15321@fbirervta.pbzchgretzou.qr>
X-PGP-Fingerprint: 6B6E 5EED 8ECF FAE7 1F61  7458 5046 7D0E 11B0 0EE8
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Spam-Scanned: 0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2008-02-24 13:10:58 (+0100), Jan Engelhardt <jengelh@computergmbh.de> wrote:
> Hi,
> 
> 
> when doing IPv6 (ping6, ssh otherhost, etc.), lockdep spews a warning in 
> 2.6.25-rc2 on the target. CONFIG_..._FRAME_POINTER is off,
I think that's the same bug I ran into. It was introduced in
69cc64d8d9 and reversed in 9ff56607468. I think Linus' tree has the
reversal by now.

Kristof
 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHwW1CUEZ9DhGwDugRAkVJAKCFxUjwfQNTtAX0Z5OquJRyNimmCgCbBgio
0voGZL/B6iaz5kSLgTbV2EY=
=CPho
-----END PGP SIGNATURE-----
