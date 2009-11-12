Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbZKLQof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbZKLQof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 11:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZKLQoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 11:44:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33797 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbZKLQoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 11:44:32 -0500
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Robert Hancock <hancockrwd@gmail.com>, "Anton D. Kachalov" <mouse@mayc.ru>,
       linux-kernel@vger.kernel.org
Subject: Re: Reading /dev/mem by dd
From: Andi Kleen <andi@firstfloor.org>
References: <4AFACC03.7080209@mayc.ru> <4AFB2822.30906@gmail.com>
	<20091112021209.GA21625@khazad-dum.debian.net>
Date: Thu, 12 Nov 2009 17:44:32 +0100
In-Reply-To: <20091112021209.GA21625@khazad-dum.debian.net> (Henrique de Moraes Holschuh's message of "Thu, 12 Nov 2009 00:12:09 -0200")
Message-ID: <878web7kwf.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh <hmh@hmh.eng.br> writes:
>
> We should.  Imaging /dev/mem is one of the oldest tricks in the book of the
> forensics people, they do it to live systems to help track down WTF happened
> to a compromised host.  This kind of crap bites them hard.

It seems more like a case of hurting themselves.

>
> IMO: if you're going to provide /dev/mem, make it as safe as possible.

That would also make it useless for people who want to access MMIO using
/dev/mem. Which is a lot of programs.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
