Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab0BJHAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 02:00:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39456
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149Ab0BJHAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 02:00:49 -0500
Date: Tue, 09 Feb 2010 23:01:04 -0800 (PST)
Message-Id: <20100209.230104.180816804.davem@davemloft.net>
To: tiago.maluta@gmail.com
Cc: linux-net@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Allow change timing values to wait slow devices
 bring up before try register an interface to IP-Config
From: David Miller <davem@davemloft.net>
In-Reply-To: <600adaf51002091944t25a36090s5cb002098c201fc6@mail.gmail.com>
References: <600adaf51002091944t25a36090s5cb002098c201fc6@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tiago Maluta <tiago.maluta@gmail.com>
Date: Wed, 10 Feb 2010 03:44:50 +0000

> I had some problems with 'slow' net devices when ic_open_devs() try to
> search for interfaces before they are registered. The solution was
> change some timing values. I propose this patch to allow user change
> this on menuconfig.

First, please use plain text attachments when posting patches.

Second, please use netdev@vger.kernel.org for reaching the
networking developers.  linux-net is for user questions only.

Lastly, others have hit this issue before, and config options
and kernel command line options are prone to failure and
hard for casual users to discover.  For one example thread
on this topic see:

http://marc.info/?l=linux-netdev&m=126319430325919&w=2

Better is just to change the defaults to higher values and
I'd like to hear some suggestions from people hitting this issue.

Thanks.
