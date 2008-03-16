Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbYCPTsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbYCPTsh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 15:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYCPTs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 15:48:27 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38119 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752353AbYCPTs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 15:48:26 -0400
X-Sasl-enc: xfbDdbtRvc7pNCEkJpqaUxxMIRc7HNATwbrWVvKbBnXo 1205696905
Date: Sun, 16 Mar 2008 16:48:23 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: =?iso-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] LED updates
Message-ID: <20080316194823.GA31782@khazad-dum.debian.net>
References: <1202380503.9519.21.camel@dax.rpnet.com> <20080207213845.GA27862@khazad-dum.debian.net> <1202422388.9519.123.camel@dax.rpnet.com> <20080316181840.GG19825@khazad-dum.debian.net> <1205695756.4524.20.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205695756.4524.20.camel@dax.rpnet.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Mar 2008, Richard Purdie wrote:
> As I understand it 2.6.26 will lose the limitation on the name size
> entirely so the problem will go away soon. I don't want to change the
> existing ABI so changing to what you describe above isn't possible. You
> could leave the devicename empty if you wish although I'd prefer you not
> to. Keeping it short might be the best option for 2.6.25.

Hmm, that means I will have to keep the short names, since I can't very
much have two different ABIs across several kernel versions... or I will
have to backport whatever is needed to expand this name size restriction
(and who knows if that's doable... I better start digging).

This won't be easy on my side :(

Well, might as well claim tpacpi as a thinkpad-acpi short handle and use it
on workqueue and kthread naming (and document it) as well as the led class.
Yuck.

> Your other patch looks ok btw although I'm not sure why you sent it
> twice. I'll queue that tomorrow.

I screwed up the prefix on the first one (used LED instead of leds). The
patches are the same.  I wrote the reason for the resend after the first
"---" separator.

Anyway, thanks for the fast reply.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
