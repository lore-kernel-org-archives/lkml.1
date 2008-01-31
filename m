Return-Path: <linux-kernel-owner+w=401wt.eu-S933324AbYAaLdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324AbYAaLdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 06:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932980AbYAaLcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 06:32:55 -0500
Received: from swsoft-msk-nat.sw.ru ([195.214.232.10]:56066 "EHLO iris.sw.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757659AbYAaLcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 06:32:53 -0500
Message-ID: <47A1B1E4.2010804@sw.ru>
Date: Thu, 31 Jan 2008 14:32:52 +0300
From: "Denis V. Lunev" <den@sw.ru>
User-Agent: Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Adrian Bunk <bunk@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, devel@openvz.org, xemul@openvz.org
Subject: [PATCH 0/3] [RAW]: proc output cleanups.
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yesterday Adrian Bunk noticed, that the commit

commit 42a73808ed4f30b739eb52bcbb33a02fe62ceef5
Author: Pavel Emelyanov <xemul@openvz.org>
Date:   Mon Nov 19 22:38:33 2007 -0800

is somewhat strange. Basically, the commit is obviously wrong as the
content of the /proc/net/raw6 is incorrect due to it.

This series of patches fixes original problem and slightly cleanups the
code around.

Signed-off-by: Denis V. Lunev <den@openvz.org>

