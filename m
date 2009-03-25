Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbZCYDbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbZCYDbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 23:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754935AbZCYDba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 23:31:30 -0400
Received: from mail.vyatta.com ([76.74.103.46]:37760 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509AbZCYDb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 23:31:29 -0400
Date: Tue, 24 Mar 2009 20:31:11 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH 15/61] net: struct device - replace bus_id with
 dev_name(), dev_set_name()
Message-ID: <20090324203111.0d3f5de1@nehalam>
In-Reply-To: <1237940825-22904-15-git-send-email-gregkh@suse.de>
References: <20090325001659.GA22461@kroah.com>
	<1237940825-22904-15-git-send-email-gregkh@suse.de>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009 17:26:19 -0700
Greg Kroah-Hartman <gregkh@suse.de> wrote:

> From: Kay Sievers <kay.sievers@vrfy.org>
> 
> Cc: davem@davemloft.net
> Cc: netdev@vger.kernel.org
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> ---
>  drivers/net/arm/ks8695net.c  |    2 +-
>  drivers/net/au1000_eth.c     |    8 ++++----
>  drivers/net/bfin_mac.c       |   12 ++++++------
>  drivers/net/bmac.c           |    2 +-
>  drivers/net/cpmac.c          |    2 +-
>  drivers/net/declance.c       |    6 +++---
>  drivers/net/depca.c          |    6 +++---
>  drivers/net/ehea/ehea_main.c |    2 +-
>  drivers/net/jazzsonic.c      |    6 ++++--
>  drivers/net/macb.c           |   10 +++++-----
>  drivers/net/macsonic.c       |   15 ++++++++-------
>  drivers/net/mv643xx_eth.c    |    2 +-
>  drivers/net/sb1250-mac.c     |   10 +++++-----
>  drivers/net/smc911x.c        |    2 +-
>  drivers/net/smc91x.c         |    2 +-
>  drivers/net/smsc911x.c       |    7 ++++---
>  drivers/net/smsc9420.c       |    4 ++--
>  drivers/net/tc35815.c        |    4 ++--
>  drivers/net/xtsonic.c        |    2 +-
>  19 files changed, 54 insertions(+), 50 deletions(-)
> 

I know this is needed, but could please put some more explicit rational
in changelog.
