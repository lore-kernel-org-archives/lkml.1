Return-Path: <linux-kernel-owner+w=401wt.eu-S1760782AbYBOT4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760782AbYBOT4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 14:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbYBOT4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 14:56:22 -0500
Received: from mx1.riseup.net ([204.13.164.18]:54824 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbYBOT4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 14:56:21 -0500
Date: Fri, 15 Feb 2008 20:56:32 +0100
From: matthias@kaehlcke.net
To: mcgrof@gmail.com, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [patch 0/3] Prism 54: Convert semaphores to mutexes
Message-ID: <20080215195632.GA22741@traven>
Mail-Followup-To: matthias@kaehlcke.net, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: quilt/0.46-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prism 54 driver: The semaphores acl->sem, stats_sem and wpa_sem are
used as mutexes, convert them to the muxex API

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
