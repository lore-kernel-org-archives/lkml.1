Return-Path: <linux-kernel-owner+w=401wt.eu-S932520AbYBBJbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbYBBJbL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758259AbYBBJa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:30:58 -0500
Received: from cantor.suse.de ([195.135.220.2]:45027 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342AbYBBJa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:30:56 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SuSE Linux Products GmbH
To: Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH] mmc: extend ricoh_mmc to support Ricoh RL5c476
Date: Sat, 2 Feb 2008 10:30:52 +0100
User-Agent: KMail/1.9.5
Cc: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew de Quincey <adq_dvb@lidskialf.net>
References: <200801311838.24743.fseidel@suse.de> <47A418E0.6040205@overt.org>
In-Reply-To: <47A418E0.6040205@overt.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802021030.53109.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 February 2008 08:16, Philip Langdale wrote:
> Again, thanks a lot for investigating and finding the appropriate magic
> incantations. My main comment is to please base this on top of my suspend/resume
> patch which Pierre said he accepted but which isn't in his tree yet - I guess
> he's busy offline right now - haven't heard from him in a while.

Yes, sorry, in the meantime i saw your suspend/resume patch .. will rebase this on
it, but also due to being a bit bussy now probably not until beginning
of next week.

> >  	struct pci_dev *fw_dev = NULL;
> > +	struct pci_dev *main_dev = NULL; /* for Ricoh RL5c476 II */
> 
> There's no need to have two pointers. One will do fine.

yes, fully agree ..

> It feels like there's a bit too much code duplication going on here, but I think
> that after you rebase the patch it'll look a lot tidier and I won't feel bad about
> it :-)

yes, also fully agree .. sadfully i was in a bit of a hurry that day needing a working
patch for a internal deadline.

> > -	struct pci_dev *fw_dev = NULL;
> > +	struct pci_dev *ctrl_dev = NULL;
> 
> Same as in probe. Just use one pointer.

Hehe, no, not here ... its "-", "+" ;-)

Thanks,
Frank
