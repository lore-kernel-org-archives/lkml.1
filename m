Return-Path: <linux-kernel-owner+w=401wt.eu-S1759226AbZDKUSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226AbZDKUSU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 16:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756823AbZDKUSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 16:18:09 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:62742 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbZDKUSI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 16:18:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=QOXMH9yHxALPQ28voXnvWu/ixa+nnhWWVn0Cta8HhRJ0kQBd043zkXxo+3000oyZ53
         cbdgvjFSPJAN5vjfAtgUJHaR4JjKTMc6qM/52lIw4XICRO0MSmGTgPRsJmaAFRN6IQ/S
         6388AFhnZWrBF/r9h96myjYmXsolnGOigQr/c=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [linux-pm] [2.6.30-rc1-git2 regressions] Hibernation broken and (minor but annoying) audio problem
Date: Sat, 11 Apr 2009 22:18:01 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc1; KDE/4.2.2; x86_64; ; )
Cc: Arjan van de Ven <arjan@linux.intel.com>, Len Brown <lenb@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Takashi Iwai <tiwai@suse.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       Heinz Diehl <htd@fancy-poultry.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
References: <200904100057.43827.rjw@sisk.pl> <49E0EC87.9080808@linux.intel.com> <alpine.LFD.2.00.0904111247320.4583@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904111247320.4583@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904112218.02159.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 of April 2009, Linus Torvalds wrote:
> On Sat, 11 Apr 2009, Arjan van de Ven wrote:
> > Now that I've been able to scan most of my mail; it looks like the
> > one-liner should just go in.
>
> Ok, I committed my one-liner, and then also reverted the ACPI battery
> workaround of removing __init, since the one-liner should fix that too.

Tested - works here|.

> 			Linus


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

