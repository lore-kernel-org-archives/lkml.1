Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbZCPN6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbZCPN6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 09:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZCPN6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 09:58:31 -0400
Received: from mailbox-us-s-12.mailhostingserver.com ([75.125.101.9]:41667
	"EHLO mailbox-us-s-12.mailhostingserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752536AbZCPN6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 09:58:30 -0400
Date: Mon, 16 Mar 2009 14:58:22 +0100
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Cliffe <cliffe@ii.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Getting the port numbers and IP address from struct socket
Message-ID: <20090316135822.GF6891@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Cliffe <cliffe@ii.net>, linux-kernel@vger.kernel.org
References: <469B31E8.6050906@murdoch.edu.au> <49BE5C33.7020101@ii.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BE5C33.7020101@ii.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, Mar 16, 2009 at 10:03:31PM +0800 Cliffe ha dit:

> This may be a simple question, but how do I determine the port numbers,  
> and IP addresses from a (struct socket)socket?

i'm far from being a networking expert, so i might be plain
wrong. after having a look at the kernel sources i think it works in
the following way:

struct inet_sock *inet = inet_sk(socket->sk);

the data you are looking for are:

inet->saddr
inet->sport
inet->daddr
inet->dport

btw: for these kind of questions it is better to write to the
kernelnewbies list (kernelnewbies@nl.linux.org)

best regards

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

      Anyone who has never made a mistake has never tried anything new
                            (Albert Einstein)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
