Return-Path: <linux-kernel-owner+w=401wt.eu-S1764885AbZEAWYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764885AbZEAWYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 18:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764450AbZEAWYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 18:24:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41808
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764153AbZEAWYe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 18:24:34 -0400
Date: Fri, 01 May 2009 15:24:29 -0700 (PDT)
Message-Id: <20090501.152429.110153503.davem@davemloft.net>
To: mpm@selenic.com
Cc: bonbons@linux-vserver.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, resend] netconsole: take care of NETDEV_UNREGISTER
 event
From: David Miller <davem@davemloft.net>
In-Reply-To: <1241110115.938.1603.camel@calx>
References: <20090429.144420.262432582.davem@davemloft.net>
	<20090430084517.6de15689@pluto.restena.lu>
	<1241110115.938.1603.camel@calx>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>
Date: Thu, 30 Apr 2009 11:48:35 -0500

> On Thu, 2009-04-30 at 08:45 +0200, Bruno Prémont wrote:
>> When netconsole is loaded and a network interface fades away (e.g. on
>> rmmod $interface_driver_module) the rmmod remains stuck and some locks
>> are taken that prevent any additional module loading/unloading as well
>> as interface up/down changes.
>> In addition kernel logs (and console) get flooded at 10s interval with
>> 
>> [  122.464065] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
>> [  132.704059] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
>> 
>> This patch lets netconsole take NETDEV_UNREGISTER event into account
>> and release the affected interface if it was in use.
>> 
>> Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
> 
> Acked-by: Matt Mackall <mpm@selenic.com>

Applied, thanks everyone.
