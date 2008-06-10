Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378AbYFJXHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbYFJXHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 19:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756413AbYFJXGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 19:06:53 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46300 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756235AbYFJXGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 19:06:52 -0400
X-Sasl-enc: iAhOs7SgYeAMCEJ+DGeTSVyD6GXKVsUHgXI0RG+a1T1P 1213139210
Date: Tue, 10 Jun 2008 20:06:45 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.25.6
Message-ID: <20080610230645.GA16711@khazad-dum.debian.net>
References: <20080609194924.GL30402@sequoia.sous-sol.org> <20080610145325.GC23351@khazad-dum.debian.net> <20080610191726.GB4218@tatooine.rebelbase.local> <20080610195747.GA18926@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610195747.GA18926@martell.zuzino.mipt.ru>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008, Alexey Dobriyan wrote:
> Person fixing a bug may not realize he fixes security-sensitive bug.

That is a valid reason, I am pretty sure everyone here (including me) has
been guilty of that one.  Which doesn't mean we can't do better to educate
ourselves on the patterns for the most common issues.  The "fix for a
null-dereference to anything that has a function pointer in it" is such a
pattern.

> Or simply doesn't care because there are 5 more to fix for today.

THAT, however, is unacceptable IMO.  If one can't be bothered, or one
doesn't have the time (or the skill, whatever) to access the severity of a
fix, he should ask for someone to do that on the commit message.  One extra
short sentence at the end of the commit message [asking for that help] is
DEFINATELY not too much to ask.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
