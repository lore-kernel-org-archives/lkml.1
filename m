Return-Path: <linux-kernel-owner+w=401wt.eu-S933007AbXIFVUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007AbXIFVUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 17:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932404AbXIFVTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 17:19:54 -0400
Received: from 184.5.221.87.dynamic.jazztel.es ([87.221.5.184]:46548 "EHLO
	traven.no-ip.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757621AbXIFVTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 17:19:53 -0400
Date: Thu, 6 Sep 2007 23:09:22 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: gregkh@suse.de, linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 0/2] Use mutexes instead of semaphores in the ELAN U132
	Host Controller Driver
Message-ID: <20070906210922.GC3081@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	gregkh@suse.de, linux-usb-users@lists.sourceforge.net,
	linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset converts sw_lock and scheduler_lock in the ELAN U132
Host Controller Driver from semaphores to the mutex API 

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

     La libertad es como la mañana. Hay quienes esperan dormidos a que
   llegue, pero hay quienes desvelan y caminan la noche para alcanzarla
                        (Subcomandante Marcos)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
