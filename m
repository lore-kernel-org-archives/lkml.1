Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbZERPAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbZERPAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 11:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZERPAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 11:00:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:39749 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752400AbZERPAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 11:00:39 -0400
X-Authenticated: #10801262
X-Provags-ID: V01U2FsdGVkX19MvLQwbTdMfNNFGu/84zlr38S/yKq4CvVbOepxg3
	INGOeVq0I6TVz8
Date: Mon, 18 May 2009 17:00:37 +0200
From: Richard Atterer <richard@2009.atterer.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Elias Oltmanns <eo@nebensachen.de>, linux-ide@vger.kernel.org
Subject: Re: s2disk hangs with kernel >=2.6.29, SATA, Gigabyte EG45M-DS2H
	(bisected)
Message-ID: <20090518150037.GA7891@arbonne.lan>
Mail-Followup-To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Elias Oltmanns <eo@nebensachen.de>, linux-ide@vger.kernel.org
References: <20090516225153.GA7883@arbonne.lan> <200905180117.28413.bzolnier@gmail.com> <20090518141646.GA6460@arbonne.lan> <200905181629.33234.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200905181629.33234.bzolnier@gmail.com>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 04:29:33PM +0200, Bartlomiej Zolnierkiewicz wrote:
> Does the one commit before 295f00042aaf6b553b5f37348f89bab463d4a469
> (namely ebdab07dad3d3a008e519b0a028e1e1ad5ecaef0) work fine?

Yes, it does; I tried that one during bisecting, and then re-tried before 
writing my first mail, just to ensure I hadn't messed something up.

IIRC I also tried to modify my 2.6.30-rc6 checkout to reinstate the calls 
to spin_unlock() and local_irq_enable_in_hardirq() that were replaced with 
spin_unlock_irq() by patch 295f000.  This also didn't cause the problem to 
go away. Anyway, I have no clue what all this code does, so that was just a 
shot in the dark! :-)

Cheers,

  Richard

-- 
  __   _
  |_) /|  Richard Atterer
  | \/¯|  http://atterer.net
  ¯ '` ¯
