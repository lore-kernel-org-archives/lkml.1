Return-Path: <linux-kernel-owner+w=401wt.eu-S1751006AbXDLPKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006AbXDLPKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 11:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbXDLPKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 11:10:36 -0400
Received: from server2.meudns3.com ([74.52.31.50]:56422 "EHLO
	server2.meudns3.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbXDLPKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 11:10:35 -0400
From: Pedro <linux_user@izecksohn.com>
To: linux-kernel@vger.kernel.org
Subject: Re: tmpfs and the OOM killer
Date: Thu, 12 Apr 2007 12:08:57 -0300
User-Agent: KMail/1.9.5
References: <200704110223.31291.linux_user@izecksohn.com> <200704120219.03171.linux_user@izecksohn.com> <20070412104256.132cd21c@the-village.bc.nu>
In-Reply-To: <20070412104256.132cd21c@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704121208.57807.linux_user@izecksohn.com>
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

I wrote:
> >   I deduce that a fail-safe application must scanf overcommit_memory,
> > warn the user and waitpid.

Alan Cox wrote:
> If you are building a fail safe system you need to look a bit beyond out
> of memory handling settings - power supplies, failover, fault tolerance
> requirements, error detection (eg ECC ram), raid arrays over
> non-electrically conductive links etc.

  If you lived here, you'ld be worried about seismic-electric impact on your 
HDD and data ;) So SIGKILL is not the hardest problem to be solved.

  Maybe it is time to write an avoidoomd.
