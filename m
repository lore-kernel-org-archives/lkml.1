Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbXJXGzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbXJXGzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 02:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755632AbXJXGzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 02:55:35 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:35531 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754960AbXJXGzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 02:55:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fNP7RgiKtCYvwlrLkkPumpySxxpOQXtQ0vPcfHoO59cSaiYG2a7zGUkpaIA8bHqYisjWJw03/qILYkIvrpGaJTljMqGhzKCKJl8e/JMTtCq+aVw7ePf64qyCRWfAHdmJNVCTyqh3M/0Z2bpmzFZdGNKnJObrTk38zPeaXkAbuXs=  ;
X-YMail-OSG: N8C7aCcVM1mDc_Xf8V4FHnN05NloLQnYtIfv1I9WVghJau94KNThyX8sl5SYJemwLoOpajzClQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: sysfs sys/kernel/ namespace (was Re: [PATCH 0/2] add new notifier function ,take2)
Date: Wed, 24 Oct 2007 16:48:55 +1000
User-Agent: KMail/1.9.5
Cc: Takenori Nagano <t-nagano@ah.jp.nec.com>
References: <471700F4.1080200@ah.jp.nec.com> <200710212200.04361.nickpiggin@yahoo.com.au> <471D4668.4090300@ah.jp.nec.com>
In-Reply-To: <471D4668.4090300@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710241648.55939.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 October 2007 10:55, Takenori Nagano wrote:
> Nick Piggin wrote:

> > One thing I'd suggest is not to use debugfs, if it is going to
> > be a useful end-user feature.
>
> Is /sys/kernel/notifier_name/ an appropriate place?

Hi list,

I'm curious about the /sys/kernel/ namespace. I had presumed that
it is intended to replace /proc/sys/ basically with the same
functionality. I _assume_ these are system software stats and
tunables that are not exactly linked to device drivers (OTOH,
where do you draw the line? eg. Would filesystems go here? Core
network algorithm tunables might, but per interface ones probably
not...).

I don't know. Is there guidelines for sysfs (and procfs for that
matter)? Is anyone maintaining it (not the infrastructure, but
the actual content)?

It's kind of ironic that /proc/sys/ looks like one of the best
organised directories in proc, while /sys/kernel seems to be in
danger of becoming a mess: it has kexec and uevent files in the
base directory, rather than in subdirectories...

