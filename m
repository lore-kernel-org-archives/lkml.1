Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbZKPTyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbZKPTyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 14:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbZKPTyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 14:54:43 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:65523 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbZKPTym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 14:54:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=op/QeSY/UxR1GdRp8cM99XaneeNPiRqPzksY25uy0EauziB3DL1AgLO8cyqsyFU8Vn
         1UDP89GdSuwPvZk69yOaTuVgoJVkmP3kbk7wkOZ8HINvPNNn/koviQ1xflQupeEQ878h
         e/6JnKf4FDhVDnCijHg7iumpZrEx2VJrRfu6w=
Date: Mon, 16 Nov 2009 11:54:43 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Johannes Stezenbach <js@sig21.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: atkbd - add forced release kays quirk for
	Samsung N130
Message-ID: <20091116195443.GE24026@core.coreip.homeip.net>
References: <20091116171814.GA26183@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091116171814.GA26183@sig21.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

On Mon, Nov 16, 2009 at 06:18:14PM +0100, Johannes Stezenbach wrote:
> Samsung N130 has the same function key quirks as the NC10.
> 
> Signed-off-by: Johannes Stezenbach <js@sig21.net>
> ---
> It would be nice if this could go into 2.6.32.  It might also be
> suitable for stable.

2.6.32 will allow manipulating force release quirk from userspace
(sysfs) so I stopped accepting in-kernel quirks like this one.

Thanks.

-- 
Dmitry
