Return-Path: <linux-kernel-owner+w=401wt.eu-S1755722AbZAJAkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbZAJAkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 19:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbZAJAkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 19:40:37 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37794 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124AbZAJAkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 19:40:36 -0500
X-Sasl-enc: J4harJ8eN/8FNdCkLu46aE79r3JTB9sQsniu5drvylRO 1231548034
Date: Fri, 9 Jan 2009 22:40:31 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Willy Tarreau <w@1wt.eu>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Kernel Blocking Firewall
Message-ID: <20090110004031.GA21537@khazad-dum.debian.net>
References: <40416.166.70.238.44.1231467823.squirrel@webmail.wolfmountaingroup.com> <20090109064658.GG5038@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109064658.GG5038@1wt.eu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Jan 2009, Willy Tarreau wrote:
> why didn't you use ipset for that ? It's designed exactly for this usage
> and is a lot easier to use than plain iptables for dynamic filtering.

Any ideas when it will hit mainline?  ipsets and PF_RING are the only ways
to get two important jobs done:  non-trivial firewalling on high-speed
links, and packet capture in said links...  and neither is in mainline AFAIK.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
