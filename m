Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbYLCO0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbYLCO0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 09:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbYLCO0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 09:26:20 -0500
Received: from mail.tmr.com ([64.65.253.246]:52141 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbYLCO0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 09:26:20 -0500
Message-ID: <493696EA.5060900@tmr.com>
Date: Wed, 03 Dec 2008 09:25:46 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081112 Fedora/1.1.13-1.fc9 pango-text SeaMonkey/1.1.13
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Bill Davidsen <davidsen@tmr.com>,
       roel kluin <roel.kluin@gmail.com>, adilger@sun.com,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext3, ext4: do_split() fix loop, with obvious	unsigned
 wrap
References: <49343AD9.4020606@gmail.com> <20081202132441.GC16172@mit.edu> <49356B96.7070900@tmr.com> <20081202215758.GE20858@mit.edu> <4935C219.3070006@tmr.com>
In-Reply-To: <4935C219.3070006@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> I seriously disagree on that, writing it as a for makes it totally 
> clear that the index initialization is part of the loop.
> I know, looks funny, not the way we have always done it, not invented 
> here...
>
Just to be clear, I didn't mean that in any bad way, just that sometimes 
a new format, even if correct and unambiguous, looks strange to the eye 
and is not used just because it jars. I still think putting 
initialization for a loop in the start of the for is defensive 
programming, perhaps I've had too many bumblers inherit my code.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


