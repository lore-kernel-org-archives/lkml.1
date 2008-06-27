Return-Path: <linux-kernel-owner+w=401wt.eu-S1750971AbYF0GJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750971AbYF0GJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 02:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbYF0GJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 02:09:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50248 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406AbYF0GIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 02:08:35 -0400
Message-ID: <486483DF.5060404@garzik.org>
Date: Fri, 27 Jun 2008 02:08:31 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Taku Izumi <izumi.taku@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
       auke-jan.h.kok@intel.com
Subject: Re: [PATCH 1/3] e1000: make ioport free
References: <485B1B8E.1060108@jp.fujitsu.com> <485B1C31.4020507@jp.fujitsu.com>
In-Reply-To: <485B1C31.4020507@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Taku Izumi wrote:
> This patch makes e1000 driver ioport-free.
> This corrects behavior in probe function so as not to request ioport
> resources as long as they are not really needed. This is based on the
> ioport-free patch of e1000 driver from Auke Kok and Tomohiro Kusumi.
> 
> 
> Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
> Signed-off-by: Taku Izumi <izumi.taku@jp.fujitsu.com>
> ---
>  drivers/net/e1000/e1000.h      |    4 +
>  drivers/net/e1000/e1000_main.c |   88 +++++++++++++++++++++++++++++++++++------
>  2 files changed, 80 insertions(+), 12 deletions(-)

ACK but failed to apply


