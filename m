Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671AbZJQUh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbZJQUh7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 16:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbZJQUh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 16:37:59 -0400
Received: from nerdhammel.gnuher.de ([88.198.0.170]:48599 "EHLO
	nerdhammel.gnuher.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbZJQUh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 16:37:58 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: Sven Geggus <lists@fuchsschwanzdomain.de>
Subject: Re: Kernel crash on 2.6.31.x (kcryptd: page allocation failure..)
Date: Sat, 17 Oct 2009 20:38:00 +0000 (UTC)
Organization: Geggus clan, virtual section
Message-ID: <hbd9v8$7rf$1@ultimate100.geggus.net>
References: <hbd4dk$5ac$1@ultimate100.geggus.net> <200910172230.13162.elendil@planet.nl>
NNTP-Posting-Host: diesel.geggus.net
X-Trace: ultimate100.geggus.net 1255811880 8047 192.168.3.2 (17 Oct 2009 20:38:00 GMT)
X-Complaints-To: usenet@geggus.net
NNTP-Posting-Date: Sat, 17 Oct 2009 20:38:00 +0000 (UTC)
Cancel-Lock: sha1:jNOPNcvUaOcEP1Fo/gpYZXZ5gWI=
X-TERMINAL: rxvt-unicode
X-OS: Debian GNU/Linux (Kernel 2.6.31-ztdummy)
User-Agent: tin/1.9.5-20090720 ("Rieclachan") (UNIX) (Linux/2.6.31-ztdummy (i686))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop <elendil@planet.nl> wrote:

> What is the _exact_ command sequence you use to reproduce it? I already 
> have a testcase, but a second test case, or a simpler one, may be useful.

Not a particular easy testcase.

This is what I did:

On the crashing machine with the dm-encrypted xfs volume:
ionice -c 3 socat TCP4-LISTEN:5555 - >backup.tar

On the source machine:
tar cv dir |socat - TCP4:targetmachine:5555

You will certainly not need to use tar.

socat /dev/zero TCP4:targetmachine:5555 should work as well.

I don't know if TCP traffic is really needed probably it is.

Regards

Sven

-- 
"We don't know the OS that God uses, but the Vatican uses Linux"
                               (Sister Judith Zoebelein, Vatican Webmaster)

/me is giggls@ircnet, http://sven.gegg.us/ on the Web
