Return-Path: <linux-kernel-owner+w=401wt.eu-S1763637AbXGFMwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763637AbXGFMwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 08:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761772AbXGFMwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 08:52:35 -0400
Received: from stinky.trash.net ([213.144.137.162]:57080 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761989AbXGFMwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 08:52:34 -0400
Message-ID: <468E3AFB.7060403@trash.net>
Date: Fri, 06 Jul 2007 14:52:11 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Philippe De Muyter <phdm@macqel.be>
CC: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] net : make netlink_seq_ops const
References: <20070706124829.GA12930@muff.macqel.be>
In-Reply-To: <20070706124829.GA12930@muff.macqel.be>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[please send networking patches to netdev]

Philippe De Muyter wrote:
> Hi all,
> 
> Make netlink_seq_ops const


Might make more sense to do a big patch for all occurences of this
in net/:

# grep "^static struct seq_operations" -r net/ | wc -l
76
