Return-Path: <linux-kernel-owner+w=401wt.eu-S966744AbXFGWHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966744AbXFGWHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966519AbXFGWEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:04:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40510 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966590AbXFGWEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:04:35 -0400
Subject: Re: [SERIAL] Don't optimise away baud rate changes when BOTHER is
	used
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, paulus@samba.org
In-Reply-To: <20070607225528.0d5e7b29@the-village.bc.nu>
References: <20070523172739.1d3a918c@the-village.bc.nu>
	 <1180012135.8303.89.camel@shinybook.infradead.org>
	 <20070524144109.7bd0f4d0@the-village.bc.nu>
	 <1180014338.8303.95.camel@shinybook.infradead.org>
	 <20070524160559.54c2c639@the-village.bc.nu>
	 <1181133010.4096.26.camel@pmac.infradead.org>
	 <20070606160310.27d6d3b8@the-village.bc.nu>
	 <1181150998.2785.13.camel@pmac.infradead.org>
	 <20070607163808.19984208@the-village.bc.nu>
	 <1181231421.2785.68.camel@pmac.infradead.org>
	 <20070607225528.0d5e7b29@the-village.bc.nu>
Content-Type: text/plain
Date: Thu, 07 Jun 2007 23:04:59 +0100
Message-Id: <1181253899.20322.3.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-07 at 22:55 +0100, Alan Cox wrote:
> Umm if your struct termios has the c_ispeed/c_ospeed fields then you
> don't need to add the new ioctls to the PPC either - the Alpha is the
> same here. 

Ah, OK. I hadn't previously noticed that setting TERMIOS_OLD only
actually affected the copy to/from user. I'll send a new patch in the
morning.

-- 
dwmw2

