Return-Path: <linux-kernel-owner+w=401wt.eu-S935455AbYEBPXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935455AbYEBPXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935110AbYEBPXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:23:19 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:36937 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934188AbYEBPXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:23:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DTlAaMVu3GLrXiH7ndKvtlk1dN4oVuGvOZ/TX23+Nxk9AIrLjd2dzkM41Svt0vl1JOoszyQEckxga0WJ4xeQ1gENcHrIyZmcG5Mxhk331AEKapV7H9MYTD4qM3thd75hPNxTKYj4Q7Sw6Jn3XpPQoZDtYMJUyODxopBew5yBOZs=
Message-ID: <3d00e6dc0805020823o267c6af8ve6a723b80ad04131@mail.gmail.com>
Date: Fri, 2 May 2008 11:23:16 -0400
From: "Khoa Nguyen" <khoa.coffee@gmail.com>
To: Roland <devzero@web.de>
Subject: Re: 24rc8: unregister_netdevice: waiting for ... to become free.
Cc: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
In-Reply-To: <004701c8abf4$4cefe820$6400a8c0@bui.materna.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <004701c8abf4$4cefe820$6400a8c0@bui.materna.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am also seeing the same thing with my vlan interface over bond
interface (2.6.24 kernel):

"unregister_netdevice: waiting for bond0.20 to become free. Usage count = 1"

This happens when "vconfig rem bond0.20" is called.

Khoa

On Thu, May 1, 2008 at 9:26 PM, Roland <devzero@web.de> wrote:

> i`m also seeing this one, but with pcnet32 - "modprobe -r pcnet32" never
> returns and
>
>  "unregister_netdevice: waiting for eth0 to become free. Usage count = 1"
>
>  being printed over and over again
>
>  lsmod |grep pcnet32 shows
>
>  pcnet32            35828    0
>  mii                      9344    1    pcnet32
>
>  i see stale ssh connection on port 22 and sshd for that session remains
> unkillable process.
>
>  roland
>
>
>
>  List:       linux-kernel
>  Subject:    Re: 24rc8: unregister_netdevice: waiting for ... to become
> free.
>  From:       Soeren Sonnenburg <kernel () nn7 ! de>
>  Date:       2008-01-29 8:59:10
>  Message-ID: 1201597150.4973.10.camel () localhost
>  [Download message RAW]
>
>  On Tue, 2008-01-22 at 22:44 -0800, David Miller wrote:
>
> > From: Soeren Sonnenburg <kernel@nn7.de>
> > Date: Wed, 23 Jan 2008 07:42:21 +0100
> >
> > > Dear all,
> > >
> > > since some 2.6.24rc version I suddenly experience such messages on
> > > console when trying to shutdown a vpn connection:
> > >
> > > unregister_netdevice: waiting for tun0 to become free. Usage count = 1
> > >
> > > or when removing an usb wlan dongle (although it was ifconfig wlan0
> > > down'd before)
> >
> > Current GIT already has a fix for this, attached below:
> >
>
>  hmmhhh, I am still seeing this problem on 2.6.24 with at least with the
>  madwifi driver...
>
>  Soeren
>
>
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-net" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
