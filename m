Return-Path: <linux-kernel-owner+w=401wt.eu-S1761068AbXEZPYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761068AbXEZPYO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 11:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbXEZPYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 11:24:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:56372 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbXEZPYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 11:24:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=WcRJJ/4GegplRHobJg9GAvgY0DX0oJDLA2n4KiPAN9nQbnM4aVd6369mjuARvjlugTuoUAq9+PevR8BzYqaL8QMLDlrRl0j0VKK7GAIInKQkY+LaMsYKHJ67EWH0sdB6VF5lglEv5GlbIwGi4sgAhoxitOriGTXWubmugZnwTIg=
Message-ID: <3d8471ca0705260823j2d6b312fkd72fe8d3f5b9673f@mail.gmail.com>
Date: Sat, 26 May 2007 17:23:59 +0200
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Tommy Vercetti" <vercetti@zlew.org>
Subject: Re: 2.6.21.1 - 97% wait time on IDE operations
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200705261505.38109@gj-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705261505.38109@gj-laptop>
X-Google-Sender-Auth: 6f60c45a002a82d4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> wait time is 90+% , which means that machine is waiting, rather than doing
> something meanwhile. (I guess).

Yes, the machine spends its time waiting for the disk to do its things
as it does not have anything else to do. Nothing to worry about. If
you want, launch some CPU bound process at the same time and the wait
time will be replaced by some user+system time but you'll gain
nothing.

Hope this helps.

-- 
Guillaume
