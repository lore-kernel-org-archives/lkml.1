Return-Path: <linux-kernel-owner+w=401wt.eu-S1762745AbZANNgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762745AbZANNgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 08:36:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbZANNgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 08:36:35 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:4362 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbZANNge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 08:36:34 -0500
Message-ID: <496DEA60.2080700@hp.com>
Date: Wed, 14 Jan 2009 08:36:32 -0500
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Pierre Habouzit <pierre.habouzit@intersec.com>,
       Wei Yongjun <yjwei@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: if backlog is 0, listening shall not be deactivated.
References: <1231926123-26196-1-git-send-email-pierre.habouzit@intersec.com>	<496DE5ED.8030609@hp.com> <20090114132124.15b68481@lxorguk.ukuu.org.uk>
In-Reply-To: <20090114132124.15b68481@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> However SCTP API explicitly states that when the backlog is 0, listening is
>> disabled.  Here is an excerpt from the draft describing this:
> 
> POSIX is an established standard, SCTP is a draft proposal. POSIX should
> win. The SCTP developers need to bring their draft API into alignment with
> POSIX.
> 
> They need to fix their draft to use a sockopt or similar to
> enable/disable listening.
> 

Here is what POSIX says:

A backlog argument of 0 may allow the socket to accept connections, in which
case the length of the listen queue may be set to an implementation-defined
minimum value.


SCTP API simply chooses to ignore the "may".  It is still fully compliant
with POSIX in this regard.

-vlad
