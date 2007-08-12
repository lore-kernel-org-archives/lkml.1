Return-Path: <linux-kernel-owner+w=401wt.eu-S937199AbXHLPSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937199AbXHLPSM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936553AbXHLPMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:12:31 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52697 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936709AbXHLPM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:12:29 -0400
Date: Sun, 12 Aug 2007 17:12:28 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Finding out socket/pipe connectivity status
Message-ID: <Pine.LNX.4.64.0708121059160.28963@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


when a pipe/socket is broken, the process trying to read/write to it 
gets SIGPIPE. Is there a way to detect whether the next read/write will 
trigger a SIGPIPE? select() does not seem helpful here.

My specific case is "ssh server svprogram", in which the ssh process is 
locally terminated with ^C, and the svprogram continues to run on the 
server (good so), and when a socket breaks, it should cleanly shut down -
ideally before the next read/write is attempted.


thanks,
	Jan
-- 
