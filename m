Return-Path: <linux-kernel-owner+w=401wt.eu-S1751206AbXLGFDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206AbXLGFDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 00:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbXLGFC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 00:02:58 -0500
Received: from main.gmane.org ([80.91.229.2]:56275 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbXLGFC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 00:02:57 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ben Pfaff <blp@cs.stanford.edu>
Subject: Re: New Address Family: Inter Process Networking (IPN)
Date: Thu, 06 Dec 2007 20:54:53 -0800
Message-ID: <873aufkste.fsf@blp.benpfaff.org>
References: <20071206053016.GA1464@cs.unibo.it> <20071206163538.GC20595@one.firstfloor.org> <47585D66.3000404@nortel.com> <20071206.194131.79623068.davem@davemloft.net> <4758CA53.7000407@nortel.com>
Reply-To: blp@cs.stanford.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 76.14.48.172
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
Cancel-Lock: sha1:DawUIUtSaLw/bNeNosbBIML8PtQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Chris Friesen" <cfriesen@nortel.com> writes:

> David Miller wrote:
>> From: "Chris Friesen" <cfriesen@nortel.com>
>>> One problem we ran into was that there are only 32 multicast groups
>>> per netlink protocol family.
>> I'm pretty sure we've removed this limitation.
> As of 2.6.23 nl_groups is a 32-bit bitmask with one bit per
> group. 

Use setsockopt(fd, SOL_NETLINK, NETLINK_ADD_MEMBERSHIP, ...) to
join an arbitrary Netlink multicast group.
-- 
"A computer is a state machine.
 Threads are for people who cant [sic] program state machines."
--Alan Cox

