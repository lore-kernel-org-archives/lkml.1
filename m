Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbYGVH75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbYGVH75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 03:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbYGVH7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 03:59:48 -0400
Received: from mailmxout.mailmx.agnat.pl ([193.239.44.238]:35847 "EHLO
	mailmxout.mailmx.agnat.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYGVH7r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 03:59:47 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VT: Restore VT fonts on switch
Date: Tue, 22 Jul 2008 09:59:41 +0200
User-Agent: PLD Linux KMail/1.9.9
References: <E1KL0tq-0001Wk-Ny@critter.phunnypharm.org> <20080721134327.3ffab96f@infradead.org> <alpine.LNX.1.10.0807212254390.23410@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0807212254390.23410@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807220959.42357.arekm@maven.pl>
X-Authenticated-Id: arekm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 July 2008, Jan Engelhardt wrote:
> On Monday 2008-07-21 22:43, Arjan van de Ven wrote:
> >On Mon, 21 Jul 2008 15:39:44 -0400
> >
> >Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> >> Not all X drivers save and restore fonts on text VTs. Add code to the
> >> kernel to explicitly save and restore them on VT switches.
> >
> >do you have a list of which ones don't ?
>
> This piece of code may be needed anyway for swsusp, which does not
> restore fonts yet.

Yeah, console is a mess after resume from ram (using s2ram).

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
