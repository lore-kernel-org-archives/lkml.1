Return-Path: <linux-kernel-owner+w=401wt.eu-S933199AbXJRWK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199AbXJRWK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760809AbXJRWKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:10:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757810AbXJRWKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:10:19 -0400
Message-ID: <4717D9BF.4010508@redhat.com>
Date: Thu, 18 Oct 2007 15:10:07 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Rik van Riel <riel@redhat.com>, Marcelo Tosatti <marcelo@kvack.org>,
       linux-kernel@vger.kernel.org
Subject: Re: OOM notifications
References: <20071018202504.GA2854@dmt>	<4717C43D.6030204@keyaccess.nl>	<20071018165238.0537eaa6@bree.surriel.com>	<4717CAEC.50203@keyaccess.nl> <20071018171857.409255de@bree.surriel.com> <4717D7B6.40102@keyaccess.nl>
In-Reply-To: <4717D7B6.40102@keyaccess.nl>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Rene Herman wrote:
> That first threshold sounds fine yes. To me, the second mostly sounds
> like a job for SIGTERM though.

I agree.  Applications shouldn't be expected to be yet more complicated
and have different levels of low memory handling.  You might want to
give a process a second shot at handling SIGDANGER but after that's it's
all about preparation for a shutdown.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHF9m/2ijCOnn/RHQRAhwjAKC38y1OLv0mE5sWHY31CwJ2ZaoAXwCglDTO
05pmpe8jMVhwM0nlCHqZyaQ=
=5DvG
-----END PGP SIGNATURE-----
