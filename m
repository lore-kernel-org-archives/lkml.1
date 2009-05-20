Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbZETMQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbZETMQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 08:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756845AbZETMQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 08:16:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:36734 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631AbZETMQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 08:16:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ciuKTruZqYuU5DRkJJb8WpQNtR/CT3D1V1IsPeCRs50uKpnQQBRTG0r1ilUiSZDAeY
         cXgdwEdyffxjAZN1s5TZAHT/p2Dh8cEjV/0SEFNCJTO/+XXjLDJP0nOpyqBXUL+awzTL
         /vur/d4qcuntQvaBmglmzBc49Agzyok7x9Dxs=
Message-ID: <4A13F49D.7000905@gmail.com>
Date: Wed, 20 May 2009 14:16:29 +0200
From: Marcin Krol <mrkafk@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Martin Steigerwald <ms@teamix.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: inotify limits - thousands (tens of thousands?) of watches
References: <4A13CCE1.5000106@gmail.com> <200905201322.15075.ms@teamix.de>
In-Reply-To: <200905201322.15075.ms@teamix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Steigerwald wrote:
> Hmmm, I think you could just run a rsync periodically. It might even be faster 
> detecting changed files. 

I beg to differ on this: rsync does quite intensive (in terms of disk 
activity and CPU activity) comparisons at the beginning of 
synchronization. It's pretty light later, true, but running rsync every 
few minutes on entire /home is IMO out of question.

> I wrote a ruby script using libinotify-ruby which does just that. I only syncs 
> on demand tough. I.e. when someplace places a special sync file in a watched 
> directory.

> That script is running productively for well over a year now.

Good to know the idea is not totally off the wall.. Thanks.

Anyway, I'll try using fsnotify / fanotify.

My main gripe with it, though, is that it is not in the mainline kernel, 
and thus in all probability it is not tested as widely as inotify.

Are there any chances for its inclusion in the near future?

Regards,
mk
