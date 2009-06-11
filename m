Return-Path: <linux-kernel-owner+w=401wt.eu-S1761680AbZFKAr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761680AbZFKAr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 20:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbZFKAru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 20:47:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:64809 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbZFKArt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 20:47:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=doGmbseKzD0Z68+GgH7+pwhpcgK6WRsTy1px6RL/gKIxSVQ/qoSXPU6plQZ50E5evT
         awWLh7eN4UZpI/9IQu9sXoYhict/bfRisDyEGVfvsuApaqKuShL7dn93o0sJcfqq3ZUl
         1WlLCw5fYOYRphMLJYjlVrUlMsrQ6w2ZfwK7c=
MIME-Version: 1.0
Date: Wed, 10 Jun 2009 18:47:50 -0600
Message-ID: <9b1675090906101747u4ab8cc89t764ba80b4eb3dcb2@mail.gmail.com>
Subject: Macbook 4G only see 3G
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

Has anyone been doing any development in the area of enabling 4G for
any PC that doesn't have an option in the BIOS?  The Mac OS X sees the
full 4G, but Linux does not.

tdamac ~ # uname -a
Linux tdamac 2.6.30-rc7-dirty #3 SMP Fri Jun 5 21:24:29 MDT 2009
x86_64 Intel(R) Core(TM)2 CPU T7400 @ 2.16GHz GenuineIntel GNU/Linux

I'm curious if there's some simple piece of code that can disable
legacy PCI assignment of that extra 1G that Mac OS X does, but not the
Linux kernel?  I know I disabled something called legacy mode or
something, in one of my 64 bit machines, and the 4G then showed up.
But, seeing the Mac uses EFI, I'm unable to do that.

If no one has done any development in that area, does anyone have any
idea where to look up the technical aspects of adding this code, and
where in the kernel I would put it if I found out how to do it?

Thanks.
