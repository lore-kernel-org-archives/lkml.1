Return-Path: <linux-kernel-owner+w=401wt.eu-S1752207AbZFHSSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbZFHSSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 14:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZFHSSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 14:18:32 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51598 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbZFHSSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 14:18:32 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A2D55E8.3070900@s5r6.in-berlin.de>
Date: Mon, 08 Jun 2009 20:18:16 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090411 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Pranith Kumar <pranith.hacks@gmail.com>
CC: greg@kroah.com, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [TRIVIAL][PATCH 1/1] Fix warning in staging/otus/ioctl.c
References: <4A2CBB99.9080908@gmail.com> <4A2CC6FA.6020904@gmail.com> <4A2CD560.8070002@s5r6.in-berlin.de> <4A2CE1A6.9000501@gmail.com> <4A2D51E6.6030607@s5r6.in-berlin.de>
In-Reply-To: <4A2D51E6.6030607@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> However, the code which you looked 
> at also has other trivial deviations from kernel style.  Notably, the 
> use of CamelCase names rather than all-lowercase with underscores. 

PS:  Name changes are already at least one level more difficult than 1:1 
type replacements, because giving _good_ names to variables/ functions 
etc. requires deeper understanding of what the code does.

> if you are interested in doing that, then you can plan ahead and hold
> off with whitespace adjusting changes (indentation, line wraps...)
> until after you did those other changes

But that's only an 'if'.  If you rather only want to work on a single 
logical step for now, e.g. type replacement, then that's surely very 
welcome too.  (My only concern about the "Fix warning..." was that 
making the warnings go away does not lead to actual improvements, or 
worse, covers up actual issues with the code.  I.e. I didn't want to 
press you in to fixing those, just to take care _not_ to paper over them.)
-- 
Stefan Richter
-=====-==--= -==- -=---
http://arcgraph.de/sr/
