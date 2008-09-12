Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYILNUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYILNUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 09:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYILNUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 09:20:32 -0400
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:55770 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751676AbYILNUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 09:20:31 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Laptop shock detection and harddisk protection
To: Tejun Heo <tj@kernel.org>, multinymous@gmail.com,
       Elias Oltmanns <eo@nebensachen.de>, Thomas Renninger <trenn@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Fri, 12 Sep 2008 15:28:49 +0200
References: <baBmH-48R-17@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1Ke8hd-0001TE-TN@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> 1. How should the shock interface look like?  As we're gonna need
>    userland daemon one way or the other, we can use the userland
>    daemon to glue all the interfaces but it would be much better to
>    have a unified interface.  Although there seem to be several
>    different variants, they don't differ all that much and creating a
>    new interface every time is painful.  I think we can get by with a
>    sysfs interface with notification.

It should provide a connection to the corresponding device. Imagine an USB
case having a sensor, being connected to a desktop system. You would want
to exactly protect the enclosed USB device, and possibly non-protected USB
devices, too, but not halt the internal disks.

