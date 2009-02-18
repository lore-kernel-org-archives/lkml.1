Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZBRBU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZBRBU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbZBRBUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:20:20 -0500
Received: from ns.suse.de ([195.135.220.2]:45811 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbZBRBUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:20:19 -0500
Date: Wed, 18 Feb 2009 02:20:16 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Nye Liu <nyet@mrv.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: modpost: Something amiss with do_hid_entry() - id->bus endianess
 wrong?
In-Reply-To: <499B0BBB.3020201@mrv.com>
Message-ID: <alpine.LNX.1.10.0902180219280.18110@jikos.suse.cz>
References: <20090217045840.GA28536@mrv.com> <499AA1B5.5090501@gmail.com> <499B0BBB.3020201@mrv.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009, Nye Liu wrote:

> > > i am having problems with endianness on the id->bus value in
> > > do_hid_entry().
> > > i think there is a "TO_NATIVE(id->bus);" missing in
> > > scripts/mod/file2alias.c:
> > Definitely! Good spotting, thanks.
> > Could you try the patch I posted a minute ago?
> Yes, it works; i posted an almost identical patch not long before you did ;)

The patch is now in Linus' tree.

Thanks for spotting this,

-- 
Jiri Kosina
SUSE Labs
