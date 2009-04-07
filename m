Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbZDGEdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbZDGEdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 00:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbZDGEcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 00:32:52 -0400
Received: from taiga.selinuxproject.org ([71.6.217.77]:40137 "EHLO
	taiga.selinuxproject.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbZDGEcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 00:32:52 -0400
X-Greylist: delayed 4682 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Apr 2009 00:32:52 EDT
Date: Mon, 6 Apr 2009 20:14:16 -0700 (PDT)
From: James Morris <jmorris@selinuxproject.org>
To: Gabriel C <nix.or.die@googlemail.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Invalid module format
In-Reply-To: <49D9E5E5.9080505@googlemail.com>
Message-ID: <alpine.LRH.2.00.0904062013440.21264@taiga.selinuxproject.org>
References: <20090401164450.f8192631.sfr@canb.auug.org.au> <20090401150928.GA5886@denkbrett.schottelius.org> <20090402123223.f31370cd.sfr@canb.auug.org.au> <49D9E5E5.9080505@googlemail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009, Gabriel C wrote:

>
> Now it does , CONFIG_MODVERSIONS is broken in Linus tree too.
>
> I reverted this commit :
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9cb610d8e35fe3ec95a2fe2030b02f85aeea83c1
>
> and after that modules loading seems to work again here.

I've been seeing the same problem, and the above fix works for me too.


- James
-- 
James Morris
<jmorris@selinuxproject.org>
