Return-Path: <linux-kernel-owner+w=401wt.eu-S1758261AbXISR1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261AbXISR1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbXISR1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:27:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbXISR1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:27:20 -0400
Message-ID: <46F15BEE.2050701@redhat.com>
Date: Wed, 19 Sep 2007 10:27:10 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: follow-up: discrepancy with POSIX
References: <46F13E8B.4050309@redhat.com>	<p73sl5aveqh.fsf@bingen.suse.de>	<46F15305.2030507@redhat.com> <20070919.095251.45154496.davem@davemloft.net> <46F156A7.5000304@redhat.com>
In-Reply-To: <46F156A7.5000304@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ulrich Drepper wrote:
> Yes, but for IPv4/6 it's not an issue.  Some implementations might
> handle all-zeros and the spec _currently_ calls for it.  In this case an
> alignment would be good.

Searching the web shows up this:

http://developer.apple.com/documentation/Darwin/Reference/ManPages/man2/connect.2.html


  Datagram sockets may dissolve the association by connecting to an
  invalid address, such as a null address or an address with the address
  family set to AF_UNSPEC (the error EAFNOSUPPORT will be harmlessly
  returned).


I.e., at least Apple implements both variants.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFG8Vvu2ijCOnn/RHQRAsSfAJkBELtiNyul8wMOjVv1x7LfvDWw/ACfR0D0
cm+k1wfhCsT4GjbF3uac+eY=
=nksN
-----END PGP SIGNATURE-----
