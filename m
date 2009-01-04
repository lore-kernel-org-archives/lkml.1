Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbZADNgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbZADNgw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 08:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbZADNgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 08:36:42 -0500
Received: from ik-out-1112.google.com ([66.249.90.180]:1412 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZADNgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 08:36:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WOIQskAoJK0Ftd//o4aodR3nQoxY8qAW04hRfXqbNLlStSk9pjx7N4cbmNg2BUyexP
         PH7xaRS836MrC+QMb9dxlyJlQSHLmFXbFAS1kTjkwLDjRBt2yAHMFZGIAAfqK3uqGgiI
         F8DguafPEFd+O6MlCWppw9h+sRx8QcSmr25bM=
Message-ID: <4960BB2D.3060000@gmail.com>
Date: Sun, 04 Jan 2009 18:35:41 +0500
From: "Alexander E. Patrakov" <patrakov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ru-RU; rv:1.8.1.19) Gecko/20081226 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       tytso@mit.edu, mtk.manpages@gmail.com, rdunlap@xenotime.net,
       linux-doc@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: document ext3 requirements
References: <20090103123813.GA1512@ucw.cz>
In-Reply-To: <20090103123813.GA1512@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
[CC: Alan Cox because of his reply in the "XFS internal error" thread]

> Using ext3 is only safe if storage subsystem meets certain
> criteria. Document those.

Thanks for this patch. However, after reading this, I have a stupid 
question: which file system should I use if I had to reinstall my 
computers from scratch now?

Ext3 means either hardware that supports barriers (not sure how to 
check, and anyway I have to use encryption on the work laptop due to the 
corporate policy) or disabling write cache (but, as Alan Cox said, this 
shortens the lifespan of the disk). Does this requirement apply to other 
journaling filesystems? Do I need journaling at all, given that I have 
an UPS on my desktop and a battery in the laptop?

-- 
Alexander E. Patrakov
