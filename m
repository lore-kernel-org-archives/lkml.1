Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbYF0GKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbYF0GKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 02:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbYF0GJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 02:09:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50253 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490AbYF0GIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 02:08:47 -0400
Message-ID: <486483EB.9080207@garzik.org>
Date: Fri, 27 Jun 2008 02:08:43 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Taku Izumi <izumi.taku@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
       auke-jan.h.kok@intel.com
Subject: Re: [PATCH 2/3] e1000e: make ioport free
References: <485B1B8E.1060108@jp.fujitsu.com> <485B1C7E.90203@jp.fujitsu.com>
In-Reply-To: <485B1C7E.90203@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Taku Izumi wrote:
> This patch makes e1000e driver ioport-free.
> This corrects behavior in probe function so as not to request ioport
> resources as long as they are not really needed.
> 
> Signed-off-by: Taku Izumi <izumi.taku@jp.fujitsu.com>
> ---
>  drivers/net/e1000e/e1000.h  |    4 +++
>  drivers/net/e1000e/netdev.c |   48 ++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 46 insertions(+), 6 deletions(-)

applied 2-3


