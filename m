Return-Path: <linux-kernel-owner+w=401wt.eu-S1756373AbZEUOUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbZEUOUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 10:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbZEUOU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 10:20:28 -0400
Received: from nerdhammel.gnuher.de ([88.198.0.170]:58599 "EHLO
	nerdhammel.gnuher.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbZEUOU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 10:20:28 -0400
Date: Thu, 21 May 2009 16:20:26 +0200
From: Sven Geggus <lists@fuchsschwanzdomain.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.29+ NFS-Server Problem "reconnect_path: npd != pd"
Message-ID: <20090521142026.GA5566@geggus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-MimeOLE: Produced By Exchange Microsoft V6.6.6
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

starting from Kernel 2.6.29.x (x=0 to 4) I get hundreds of the
following messages on my NFS-Server:

reconnect_path: npd != pd

The system works fine using 2.6.27.x

Unfortunatele the message is not harmless, because the client gets stale
NFS handles which is especially troublesome on diskless Workstations
using NFS root.

Regards

Sven

P.S.: The userland in use is Debian stable (lenny).

-- 
The main thing to note is that when you choose open source you don't
get a Windows operating system.
                                  (from http://www.dell.com/ubuntu)
/me is giggls@ircnet, http://sven.gegg.us/ on the Web
