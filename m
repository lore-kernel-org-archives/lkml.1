Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbXD0ARJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbXD0ARJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 20:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbXD0ARJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 20:17:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34698 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220AbXD0ARI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 20:17:08 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <463140D1.8060002@s5r6.in-berlin.de>
Date: Fri, 27 Apr 2007 02:16:17 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, ben.collins@ubuntu.com,
       linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: [-mm patch] unexport highlevel_host_reset
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <20070426234732.GE3468@stusta.de>
In-Reply-To: <20070426234732.GE3468@stusta.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> highlevel_host_reset no longer has any modular users.

Thanks, I missed this when I removed the last usage outside the 1394
core.  Committed to linux1394-2.6.git.
-- 
Stefan Richter
-=====-=-=== -=-- ==-==
http://arcgraph.de/sr/
