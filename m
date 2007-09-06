Return-Path: <linux-kernel-owner+w=401wt.eu-S1757712AbXIFNiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbXIFNiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 09:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755811AbXIFNiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 09:38:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbXIFNiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 09:38:11 -0400
Date: Thu, 6 Sep 2007 09:35:51 -0400
From: Bill Nottingham <notting@redhat.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: davide rossetti <davide.rossetti@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: origin of __tmp1930643048 network device name: kernel-space or
	user-space
Message-ID: <20070906133551.GA25155@nostromo.devel.redhat.com>
Mail-Followup-To: Jan Engelhardt <jengelh@computergmbh.de>,
	davide rossetti <davide.rossetti@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <6e7a378f0709041014m24448117s96d6f9b60fad7872@mail.gmail.com> <Pine.LNX.4.64.0709061448390.25942@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709061448390.25942@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt (jengelh@computergmbh.de) said: 
> >dear all,
> >I'm trying to track down a problem on a Sun V40Z server with 4 network
> >devices grabbing random ethX device names. now, trying to force the
> >device names to what I want, I got a __tmpXXXXX form of device name,
> >which I think is a half-configured device... but which piece of
> >software is to blame ??? kernel, udev, hotplug
> 
> Look into dmesg. If the device was once known as ethX or similar,
> then it is userspace to blame.

It's userspace.

<off-topic for l-k, but while I'm here...>

I'm assuming you're running some sort of Fedora/RHEL/
derivative; this is what you get when you have a device that starts
out named ethX, but which needed to be renamed so that an already
configured ethX could be changed to that name.

For the new device, either add a HWADDR in a ifcfg-ethX file for
that interface, add something to /etc/mactab, or add a udev rule.

Bill
