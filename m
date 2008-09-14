Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbYINTBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbYINTBM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 15:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbYINTA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 15:00:56 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:32803 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753849AbYINTAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 15:00:55 -0400
X-Greylist: delayed 1336 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Sep 2008 15:00:54 EDT
X-Sasl-enc: WFzxLZ8nL9/j2YV3SsTm93WCmK3QLtaPCCK1H2MZJ9hh 1221417516
Date: Sun, 14 Sep 2008 15:38:29 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Helge Deller <deller@gmx.de>, Jan Beulich <jbeulich@novell.com>,
       linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: __initdata and struct dmi_system_id?
Message-ID: <20080914183829.GB18150@khazad-dum.debian.net>
References: <48C0C786.5020809@freemail.hu> <48CCBD83.1030001@freemail.hu> <20080914113316.GA27289@khazad-dum.debian.net> <48CD3B4C.8010106@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48CD3B4C.8010106@freemail.hu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Sep 2008, Németh Márton wrote:
> Henrique de Moraes Holschuh wrote:
> > On Sun, 14 Sep 2008, Németh Márton wrote:
> >> The other interesting question on this topic is that what about the
> >> error message strings which are used as parameter of the printk() calls.
> >> Those strings are combined together for a function which is marked with
> >> __init and the functions which are normal functions. The strings which
> >> are only used by the functions marked with __init could be freed, but
> >> the strings of the normal functions shouldn't be.
> > 
> > Yeah, if we could get them all in a init.rodata section, we could just throw
> > them away along with the init section afterwards...
> > 
> > I do think I have seen a patch about init.rodata in LKML not too long ago,
> > though.
> 
> Do you mean this one?

Yeah.  I don't know if it does (or is related to) what you want, though.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
