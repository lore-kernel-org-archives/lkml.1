Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbYFBJB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbYFBJB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbYFBJBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:01:48 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:41377 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751786AbYFBJBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:01:48 -0400
Message-ID: <4843B6EE.8080104@davidnewall.com>
Date: Mon, 02 Jun 2008 18:31:34 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Willy Tarreau <w@1wt.eu>, Harald Dunkel <harald.dunkel@t-online.de>,
       Joe Peterson <joe@skyrush.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@redhat.com>
Subject: Re: 2.6.25.3: su gets stuck for root
References: <48434D57.6030801@skyrush.com>	<48438126.3080308@t-online.de>	<20080602053256.GF5609@1wt.eu> <20080602091016.571dda7c@core>
In-Reply-To: <20080602091016.571dda7c@core>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Not really. The task would get suspended if it attempted to change the
> tty settings while not being session leader. This is part of the POSIX
> and BSD job control.

I haven't heard about this new restriction, but it begs the observation
that stty, when forked from a shell (the usual case), is never a session
leader.
