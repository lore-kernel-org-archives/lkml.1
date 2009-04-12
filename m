Return-Path: <linux-kernel-owner+w=401wt.eu-S1757002AbZDLOZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbZDLOZf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 10:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbZDLOZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 10:25:24 -0400
Received: from eric.schwarzvogel.de ([194.97.4.250]:55060 "EHLO
	eric.schwarzvogel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbZDLOZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 10:25:23 -0400
X-Greylist: delayed 2177 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Apr 2009 10:25:23 EDT
Date: Sun, 12 Apr 2009 15:49:02 +0200
From: Tobias Klausmann <klausman@schwarzvogel.de>
To: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Subject: Re: alpha: half done futex implementation
Message-ID: <20090412134902.GA3760@eric.schwarzvogel.de>
Mail-Followup-To: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
References: <b4198de60904111755u5c2078c7xcc689dbd78aeb957@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4198de60904111755u5c2078c7xcc689dbd78aeb957@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi! 

30-rc1 doesn't compile on alpha:

net/socket.c: In function 'sock_alloc':
net/socket.c:496: error: implicit declaration of function 'percpu_add'
net/socket.c:496: error: 'sockets_in_use' undeclared (first use in this function)
net/socket.c:496: error: (Each undeclared identifier is reported only once
net/socket.c:496: error: for each function it appears in.)
net/socket.c: In function 'sock_release':
net/socket.c:538: error: implicit declaration of function 'percpu_sub'
net/socket.c:538: error: 'sockets_in_use' undeclared (first use in this function)

I vaguely remember seeing discussion about this on lkml, but I
can't find it right now.

gcc is 4.3.3. Distro is Gentoo, machine is a UP1500 (Nautilus).

Regards,
Tobias

-- 
Save a tree - disband an ISO working group today.
