Return-Path: <linux-kernel-owner+w=401wt.eu-S1760747AbXISRrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760747AbXISRrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbXISRrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:47:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbXISRrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:47:08 -0400
Message-ID: <46F1608E.7060908@redhat.com>
Date: Wed, 19 Sep 2007 10:46:54 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: netdev <netdev@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: follow-up: discrepancy with POSIX
References: <46F13E8B.4050309@redhat.com> <p73sl5aveqh.fsf@bingen.suse.de> <46F15305.2030507@redhat.com> <20070919172653.GB18045@one.firstfloor.org>
In-Reply-To: <20070919172653.GB18045@one.firstfloor.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andi Kleen wrote:
>> But the spec calls for a "null address" to be used and that's in my
>> understanding something different from using AF_UNSPEC.
> 
> memset(&sockaddr, 0, sizeof(sockaddr)) should give you AF_UNSPEC

But the spec calls for <quote>null address for the protocol</quote>.

That means the family for the null address is the same as the family of
the socket.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFG8WCO2ijCOnn/RHQRAgtsAJ9qTFVj5QQbVG/hUflxo/6uPOfl4QCdHSX8
wi2GX7B0pht8VDaswYLqdpM=
=sMSg
-----END PGP SIGNATURE-----
