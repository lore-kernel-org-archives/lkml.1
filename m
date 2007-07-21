Return-Path: <linux-kernel-owner+w=401wt.eu-S937224AbXGUQRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937224AbXGUQRT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 12:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761923AbXGUQRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 12:17:10 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:40406 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762003AbXGUQRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 12:17:09 -0400
Date: Sat, 21 Jul 2007 18:17:08 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Matthew Wilcox <matthew@wil.cx>
cc: Simon Arlott <simon@fire.lp0.eu>, Denis Cheng <crquan@gmail.com>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] run scripts/Lindent on it to match Documentation/CodingStyle
In-Reply-To: <20070720170743.GF14791@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0707211816030.21737@fbirervta.pbzchgretzou.qr>
References: <1184489571313-git-send-email-crquan@gmail.com>
 <4699EEA9.6070709@simon.arlott.org.uk> <20070720170743.GF14791@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 20 2007 11:07, Matthew Wilcox wrote:
>sed -i -e 's/^\t*      \(\w*:\)/ \1/' "$@"
>
>Any regexp ninjas want to have a go at something better?

You want \w+.

[ perl -i -pe 's/^\t* {6}(\w+:)/ $1/' "$@"
  Whether that is "better" depends on the user who uses it :) ]



	Jan
-- 
