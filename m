Return-Path: <linux-kernel-owner+w=401wt.eu-S1758748AbYBRUrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbYBRUrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:47:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbYBRUqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:46:54 -0500
Received: from mx1.riseup.net ([204.13.164.18]:48728 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbYBRUqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:46:53 -0500
Message-Id: <20080218194533.185137318@kaehlcke.net>
User-Agent: quilt/0.46-1
Date: Mon, 18 Feb 2008 20:45:33 +0100
From: matthias@kaehlcke.net
To: wolfgang@iksw-muees.de, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [patch 0/3] USB Auerswald ISDN: Convert semaphores to mutexes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB Auerswald ISDN driver: The semaphores cp->mutex, ccp->readmutex and ccp->mutex are used as mutexes, convert them to the muxex API

-- 
Matthias Kaehlcke
Linux System Developer
Barcelona

              We build too many walls and not enough bridges
                             (Isaac Newton)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
