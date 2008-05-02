Return-Path: <linux-kernel-owner+w=401wt.eu-S933347AbYEBBcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347AbYEBBcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 21:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756152AbYEBBbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 21:31:55 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:54442 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936AbYEBBby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 21:31:54 -0400
Message-ID: <004701c8abf4$4cefe820$6400a8c0@bui.materna.com>
From: "Roland" <devzero@web.de>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-net@vger.kernel.org>
Subject: Re: 24rc8: unregister_netdevice: waiting for ... to become free.
Date: Fri, 2 May 2008 03:26:28 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-Provags-ID: V01U2FsdGVkX1+DMj3kaP/u5MjZtPjWpCKDveP9kOBSwgyLcVjq
	mAWE56kzKTwuqUDsWyhLC+6OWU8NFrsr75vekzXdqLkpoOig0O
	5h1Lr7WAc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i`m also seeing this one, but with pcnet32 - "modprobe -r pcnet32" never 
returns and

"unregister_netdevice: waiting for eth0 to become free. Usage count = 1"

being printed over and over again

lsmod |grep pcnet32 shows

pcnet32            35828    0
mii                      9344    1    pcnet32

i see stale ssh connection on port 22 and sshd for that session remains 
unkillable process.

roland



List:       linux-kernel
Subject:    Re: 24rc8: unregister_netdevice: waiting for ... to become free.
From:       Soeren Sonnenburg <kernel () nn7 ! de>
Date:       2008-01-29 8:59:10
Message-ID: 1201597150.4973.10.camel () localhost
[Download message RAW]

On Tue, 2008-01-22 at 22:44 -0800, David Miller wrote:
> From: Soeren Sonnenburg <kernel@nn7.de>
> Date: Wed, 23 Jan 2008 07:42:21 +0100
>
> > Dear all,
> >
> > since some 2.6.24rc version I suddenly experience such messages on
> > console when trying to shutdown a vpn connection:
> >
> > unregister_netdevice: waiting for tun0 to become free. Usage count = 1
> >
> > or when removing an usb wlan dongle (although it was ifconfig wlan0
> > down'd before)
>
> Current GIT already has a fix for this, attached below:

hmmhhh, I am still seeing this problem on 2.6.24 with at least with the
madwifi driver...

Soeren


