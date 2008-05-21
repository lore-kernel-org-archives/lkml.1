Return-Path: <linux-kernel-owner+w=401wt.eu-S935599AbYEUPaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935599AbYEUPaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 11:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761098AbYEUP37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 11:29:59 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:36557 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758109AbYEUP36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 11:29:58 -0400
Message-ID: <48343F99.4030803@s5r6.in-berlin.de>
Date: Wed, 21 May 2008 17:28:25 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: jszhang3@mail.ustc.edu.cn
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       krh@redhat.com
Subject: Re: [PATCH] firewire: fix some broken hardware NMI interrupt
References: <411375292.14780@ustc.edu.cn>
In-Reply-To: <411375292.14780@ustc.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jszhang3@mail.ustc.edu.cn wrote:
> Some broken pci-1394 card does not clear completely on-chip memory during boot, it
> may cause pci parity error, then NMI interrupt.

Which card?

Is the problem still present in linux-2.6.26-rc3?

Or if you don't want to test 2.6.26-rc yet, please test 2.6.25.4 with
the firewire patchkit from
http://me.in-berlin.de/~s5r6/linux1394/updates/.  There were changes to
fw-ohci which influence chip initialization.
-- 
Stefan Richter
-=====-==--- -=-= =-=-=
http://arcgraph.de/sr/
