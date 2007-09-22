Return-Path: <linux-kernel-owner+w=401wt.eu-S1753666AbXIVUhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbXIVUhh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 16:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbXIVUh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 16:37:29 -0400
Received: from main.gmane.org ([80.91.229.2]:55800 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbXIVUh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 16:37:28 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Oleg Verych (nntp)" <olecom@flower.upol.cz>
Subject: Re: memset as memzero
Date: Sat, 22 Sep 2007 20:37:06 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnffb04u.d4n.!gmane?olecom.ENOMSG@flower.upol.cz>
References: <20070922124659.741cca42@laptopd505.fenrus.org> <E1IZAbA-0001uz-00@calista.eckenfels.net>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

22-09-2007, Bernd Eckenfels:
> In article <20070922124659.741cca42@laptopd505.fenrus.org> you wrote:
>> it doesn't add value.... memset with a constant 0 is just as fast
>> (since the compiler knows it's 0) than any wrapper around it, and the
>> syntax around it is otherwise the same.

linux/arch/x86_64/lib/memset.S isn't file for compile, but for
assembler, isn't it? Removing argument processing will have size effect.

> it would however allow easier changing if you need to add a page cleaning
> system (for example new architecture which has support for it).
[]

> On the other hand, is memset used for anything else than zero filling
> or redzone "filling"?

There are non zero ones (not sure what redzone is, though).

> Gruss
> Bernd
(Here are reply-to-all people, BTW)
_____

