Return-Path: <linux-kernel-owner+w=401wt.eu-S1763037AbYCFVUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763037AbYCFVUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYCFVUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:20:06 -0500
Received: from jbanks.dsl.xmission.com ([204.228.152.159]:48105 "EHLO
	mail.bakbone.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752068AbYCFVUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:20:05 -0500
X-Greylist: delayed 2566 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2008 16:20:04 EST
From: Justin Banks <justinb@bakbone.com>
Date: Thu, 6 Mar 2008 13:38:41 -0700
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: FW: Linux question
Message-ID: <20080306203841.GA4282@bleen.domain.actdsltmp>
References: <DEE40752C8AF224BB890E455C7B8E0FE042B84B112@G6W0268.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DEE40752C8AF224BB890E455C7B8E0FE042B84B112@G6W0268.americas.hpqcorp.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miller, Mike (OS Dev) wrote
> Is there a way in to limit the kernel to seeing only the cores on a
> single processor and ignore all other processor cores (eg. leave
> them in HALT)?

Can't you just echo 0 into /sys/devices/system/cpu/cpuN/online where the
/sys/devices/system/cpu/cpuN/topology/physical_package_id isn't the one
you want to keep online?

-justinb

-- 
Justin Banks
BakBone Software
justinb@bakbone.com
