Return-Path: <linux-kernel-owner+w=401wt.eu-S1030188AbXDKTh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030188AbXDKTh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 15:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030197AbXDKTh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 15:37:59 -0400
Received: from server2.meudns3.com ([74.52.31.50]:46704 "EHLO
	server2.meudns3.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030188AbXDKTh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 15:37:58 -0400
X-Greylist: delayed 51194 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Apr 2007 15:37:58 EDT
From: Pedro <linux_user@izecksohn.com>
To: linux-kernel@vger.kernel.org
Subject: tmpfs and the OOM killer
Date: Wed, 11 Apr 2007 02:23:31 -0300
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704110223.31291.linux_user@izecksohn.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server2.meudns3.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - izecksohn.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  After suffering some days from a not|mis configured tmpfs,

  As the OOM killer is not Posix,

  Better than to kill processes would be to resize tmpfs, to use tmpfs empty 
space.

  I'm using kernel 2.6.20.4. If someone ask I'll send a test application.
