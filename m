Return-Path: <linux-kernel-owner+w=401wt.eu-S2992533AbXDLOgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992533AbXDLOgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 10:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992546AbXDLOgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 10:36:48 -0400
Received: from server2.meudns3.com ([74.52.31.50]:53841 "EHLO
	server2.meudns3.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992533AbXDLOgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 10:36:48 -0400
From: Pedro <linux_user@izecksohn.com>
To: linux-kernel@vger.kernel.org
Subject: Re: tmpfs and the OOM killer
Date: Thu, 12 Apr 2007 11:35:32 -0300
User-Agent: KMail/1.9.5
References: <200704110223.31291.linux_user@izecksohn.com> <200704120219.03171.linux_user@izecksohn.com> <20070412112545.GA28148@thunk.org>
In-Reply-To: <20070412112545.GA28148@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704121135.32160.linux_user@izecksohn.com>
X-PopBeforeSMTPSenders: linux_user@izecksohn.com
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

On Thursday 12 April 2007 08:25, Theodore Tso wrote:
> likely going to be in deep trouble anyway.  Even if you disable the
> OOM killer, now random malloc()'s will start returning NULL because
> your system doesn't have enough memory.  Do you have intelligent error
> handling and recovery mechanisms for every single malloc() failure?

  When malloc return NULL, the process may tell the user ENOMEM.
  When OOM kill the process, the user claim the program sometimes die.
