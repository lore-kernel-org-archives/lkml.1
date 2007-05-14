Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbXENRT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbXENRT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 13:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbXENRTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 13:19:20 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60727 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373AbXENRTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 13:19:20 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <464899AE.9070206@s5r6.in-berlin.de>
Date: Mon, 14 May 2007 19:17:34 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>, mgarski@post.pl,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Convert files to UTF-8 and some cleanups
References: <4647A52A.8000709@post.pl> <4647A868.4070201@post.pl> <46486EAE.3060009@s5r6.in-berlin.de> <alpine.DEB.0.98.0705141126550.19220@sigma.j-a-k-j.com> <46488D6A.3030608@s5r6.in-berlin.de> <20070514164608.GS7984@stusta.de>
In-Reply-To: <20070514164608.GS7984@stusta.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> The problem is that the unconverted characters are always invalid UTF-8 [1],
> and it's 100% correct for a MUA to convert these invalid UTF-8 
> characters to replacement characters - if a MUA claims to send valid
> charset="utf-8", it is simply not allowed to preserve the byte codes.
...
> [1] except for some cases with two or more non 7bit ASCII 
>     characters in a row

OK, I missed that, sorry.  Then

	Content-type: text/plain; charset="unknown-8bit"

can be put to good use.
But as I said, at least a diffstat would be nice.
-- 
Stefan Richter
-=====-=-=== -=-= -===-
http://arcgraph.de/sr/
