Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbZGOOfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbZGOOfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 10:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbZGOOfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 10:35:13 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35584 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752485AbZGOOfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 10:35:12 -0400
X-Sasl-enc: KtWw8q43M2bkZtXNwgfVUg6B8xPt4NgubLhMUaNbZBUd 1247668511
Date: Wed, 15 Jul 2009 11:35:09 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31-rc2: thinkpad boots with backlight low
Message-ID: <20090715143509.GC22098@khazad-dum.debian.net>
References: <20090714092513.GB2010@elf.ucw.cz>
 <20090715112204.GA16289@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090715112204.GA16289@yamamaya.is-a-geek.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is one thing that comes to mind: display power management.

Is anything, by chance, setting the backlight devices to low power mode
on machine restart?  The backlight drivers would try to set brightness
to 0 when it cannot turn the display off for real...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
