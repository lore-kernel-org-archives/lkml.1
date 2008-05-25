Return-Path: <linux-kernel-owner+w=401wt.eu-S1762954AbYEYMdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762954AbYEYMdh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 08:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756942AbYEYMd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 08:33:28 -0400
Received: from mout5.freenet.de ([195.4.92.95]:37496 "EHLO mout5.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651AbYEYMd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 08:33:27 -0400
From: Sascha Sommer <saschasommer@freenet.de>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: [PATCH] MMC/SD host driver for Ricoh Bay1Controllers
Date: Sun, 25 May 2008 14:33:15 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       sdricohcs-devel@lists.sourceforge.net
References: <200804271617.53438.saschasommer@freenet.de> <20080525124601.4d8d48cc@mjolnir.drzeus.cx> <20080525125422.0ec82f74@mjolnir.drzeus.cx>
In-Reply-To: <20080525125422.0ec82f74@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805251433.16594.saschasommer@freenet.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sonntag, 25. Mai 2008, Pierre Ossman wrote:
> Just to be clear, the only thing holding this patch back is the
> reliance on opcodes. Once that can be fixed then I'll merge the driver.
>
> (And by fix I don't mean "make those opcodes work", I mean "figure out
> the command properties instead of lists of opcodes")
>

I think I was able to fix most of the problems you pointed out in the other 
mail. There still is some |=64 for ACMDs. The SEND_SCR cmd doesn't work with 
out it. I asked some users to test the new version and will send a new patch 
after Linuxtag. Right now the code can be found at
http://sdricohcs.svn.sourceforge.net/viewvc/sdricohcs/sdricoh_cs/sdricoh_cs.c?revision=71&view=markup

The busy signal handling is not fixed yet and I think something similar will 
also be required for the test that checks when the data has been read from 
the card so that the driver does not waste to many cpu cycles.

Regards

Sascha
 
