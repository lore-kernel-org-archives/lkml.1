Return-Path: <linux-kernel-owner+w=401wt.eu-S1759329AbXEaDrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbXEaDrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 23:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067AbXEaDrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 23:47:39 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:25606 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbXEaDri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 23:47:38 -0400
Message-ID: <465E4551.8050504@chelsio.com>
Date: Wed, 30 May 2007 20:47:29 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: divy@chelsio.com
CC: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 4/5] cxgb3 - Stop mac RX when changing MTU
References: <20070530170144.22843.74669.stgit@localhost.localdomain>
In-Reply-To: <20070530170144.22843.74669.stgit@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 May 2007 03:47:10.0897 (UTC) FILETIME=[5E4C5210:01C7A336]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

divy@chelsio.com wrote:
> From: Divy Le Ray <divy@chelsio.com>
>
> Rx traffic needs to be halted when the MTU is changed
> to avoid a potential chip hang.
> Reset/restore MAC filters around a MTU change.
> Also fix the pause frames high materwark setting.
>
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
>   

This patch has a flaw. The register used to stop broadcast/multicast 
traffic is wrong.
Please ignore this instance. I'm resending it.

Divy
