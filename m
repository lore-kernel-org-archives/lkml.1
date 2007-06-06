Return-Path: <linux-kernel-owner+w=401wt.eu-S932234AbXFFRab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbXFFRab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbXFFRaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:30:15 -0400
Received: from canuck.infradead.org ([209.217.80.40]:40154 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678AbXFFRaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:30:12 -0400
Subject: Re: [SERIAL] Don't optimise away baud rate changes when BOTHER is
	used
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, paulus@samba.org
In-Reply-To: <20070606160310.27d6d3b8@the-village.bc.nu>
References: <20070523172739.1d3a918c@the-village.bc.nu>
	 <1180012135.8303.89.camel@shinybook.infradead.org>
	 <20070524144109.7bd0f4d0@the-village.bc.nu>
	 <1180014338.8303.95.camel@shinybook.infradead.org>
	 <20070524160559.54c2c639@the-village.bc.nu>
	 <1181133010.4096.26.camel@pmac.infradead.org>
	 <20070606160310.27d6d3b8@the-village.bc.nu>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 18:29:58 +0100
Message-Id: <1181150998.2785.13.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 16:03 +0100, Alan Cox wrote:
> Yep - and there are some other changes needed as well once everyone
> gets their ports properly lined up (notably handing back the actual
> speed). 

Yeah, probably. This was was required just to get the speed thing to
pass basic testing though.

You earlier made a cryptic comment about asm-generic and said the
PowerPC patch wouldn't work -- I didn't understand, and it doesn't seem
to be empirically confirmed. Can you eludicate?

-- 
dwmw2

