Return-Path: <linux-kernel-owner+w=401wt.eu-S935068AbXEVVwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935068AbXEVVwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 17:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762699AbXEVVw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 17:52:27 -0400
Received: from rtr.ca ([64.26.128.89]:1909 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756427AbXEVVw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 17:52:27 -0400
Message-ID: <46536616.2050500@rtr.ca>
Date: Tue, 22 May 2007 17:52:22 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Anand Jahagirdar <anandjigar@gmail.com>
Cc: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: Fork Bombing Attack
References: <25ae38200705170745t4a80e7eer413b3c2bb0c5a327@mail.gmail.com>	 <4051.1179414105@turing-police.cc.vt.edu> <25ae38200705180413s741cac1bw9fe0dc57cecc2a91@mail.gmail.com>
In-Reply-To: <25ae38200705180413s741cac1bw9fe0dc57cecc2a91@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anand Jahagirdar wrote:
> Hello All
>           I tried to execute a program which creates 8152 process.(
> i=0; while( i<14) i++ fork(); )  with ulimit 8200. This program
> created 8152 processes and then stopped and came back to command
> prompt. this proves that my machine do have sufficient resources to
> create 8000 processes.

Perhaps, but it does not necessarily result in 8000+ processes
all in existence at the same time.  Unless there's more to that
program than the one line you show above.
