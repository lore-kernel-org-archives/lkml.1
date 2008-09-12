Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbYILFql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbYILFql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 01:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYILFqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 01:46:30 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60780 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbYILFq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 01:46:29 -0400
Date: Fri, 12 Sep 2008 01:46:27 -0400 (EDT)
From: Jan Engelhardt <jengelh@medozas.de>
To: Grant Coady <gcoady.lk@gmail.com>
cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       Netfilter Developer Mailing List 
	<netfilter-devel@vger.kernel.org>
Subject: Re: [stable] regression in iptables: recent filter
In-Reply-To: <a4ojc4l86ro7kstsefumugi56s88v3fm91@4ax.com>
Message-ID: <alpine.LNX.1.10.0809120145220.24265@fbirervta.pbzchgretzou.qr>
References: <ejijc4dc92n75s2el334e7dgdanngs7qv3@4ax.com> <20080912031132.GA6443@x200.localdomain> <a4ojc4l86ro7kstsefumugi56s88v3fm91@4ax.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-09-11 23:29, Grant Coady wrote:
>On Fri, 12 Sep 2008 07:11:32 +0400, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>>On Fri, Sep 12, 2008 at 11:53:35AM +1000, Grant Coady wrote:
>>> Last known good kernel: 2.6.24.7
>>> 
>>> # iptables -N calmrate
>>> # iptables -A calmrate -p tcp -m state --state NEW \
>>> 	-m recent --name listrate --update --rttl \
>>> 	--seconds 60 --hitcount 60 -j DROP
>>> iptables: Unknown error 4294967295

Try upgrading the iptables binary as a freetime project.
Because if the match check returned false, and the Xtables
core subsequently -EINVAL, you would get

iptables: Invalid argument
