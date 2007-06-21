Return-Path: <linux-kernel-owner+w=401wt.eu-S1759026AbXFURuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbXFURuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756476AbXFURuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:50:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57919 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169AbXFURuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:50:44 -0400
From: Jan Kandziora <jjj@gmx.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Limiting load of certain processes
Date: Thu, 21 Jun 2007 19:50:40 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706211950.40825.jjj@gmx.de>
X-Provags-ID: V01U2FsdGVkX1/Fm8M3Z65O9TeOVd+BuL1tyUlUpRxqvWxBlbP
 wpzYKtEtvEwdBqY1TaigG2CLXmsSjaquMH8L9UVZfRrlNd86U1
 Ha/CxF0pdhVfFGXqAoTkA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I like to use an old DOS/Clipper application through DOSEMU on a Linux
application server in a hotel. It works, but (as usual with DOS), it causes
a processor load of 100% in certain situations, while just waiting for user
interaction.

That's kind of stupid, as power saving is heavily disturbed by such a
program and other applications loose some responsiveness. I asked the DOSEMU 
crowd how to address this problem and got the following answers:

* "nice" the process to address the latter problem (ok, that's obvious), but
  the load of "1" is still there.
* Configure dosemu that way the program is suspended if the dosemu window is
  iconified, but users are lazy.
* And I learned there's a "tamedos" DOS application which works a little
  (tears down CPU usage to 50%), but that's not enough in my view.

All that is not really great, I think. My question now is: Is there already
a way to advise the linux scheduler to limit CPU usage of certain
processes? Or do I have to develop such a thing myself?

Any better ideas?

Kind regards

        Jan
