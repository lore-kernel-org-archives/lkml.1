Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbZKIMV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbZKIMV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 07:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbZKIMV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 07:21:29 -0500
Received: from smtprelay01.ispgateway.de ([80.67.31.24]:39919 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbZKIMV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 07:21:28 -0500
Message-ID: <4AF8094C.3040104@ladisch.de>
Date: Mon, 09 Nov 2009 13:21:32 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Daniel Mack <daniel@caiaq.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: make the default cursor shape configurable
References: <4AF7D439.4030305@ladisch.de>	<20091109091044.GX29442@buzzloop.caiaq.de>	<4AF7DDC1.4090006@ladisch.de>	<20091109095316.6283fbd6@lxorguk.ukuu.org.uk>	<4AF7FC64.6030904@ladisch.de> <20091109114600.4d91b90e@lxorguk.ukuu.org.uk>
In-Reply-To: <20091109114600.4d91b90e@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> > The justification from Daniel's original patch was:
> > | For embedded systems, the blinking cursor at startup time can be
> > | annoying and unintended.
> > 
> > Would a simple "Disable cursor by default" switch more acceptable?
> 
> Well I guess you could just make the default cursor define a variable and
> mark it MODULE_PARAM ?

The original thread started here: <http://lkml.org/lkml/2009/11/5/71>.
To quote Andrea:
| There's no need to choose if we want the blinking cursor or not
| at each boot.


Clemens
