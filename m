Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbXHRF4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbXHRF4R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 01:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbXHRF4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 01:56:07 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:54463 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbXHRF4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 01:56:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=TXthuhIDDua333+b7DDa0h5NNqMyW85fu7BkLZskoa1+8vYhrO1F23JUI0G9SAHJ/4wgePSU9P3/74WLRcK/Uz+56MyRr9sTteuOoRbXL4aMEnsN/eFf8LWUNgxr0O2rq4nYkUgAXZ9r4xzxiKb2HzupiRWs1WyUPaSWnDKSNsw=
Message-ID: <4746469c0708172256g164049f0qeaf02462aebd6d27@mail.gmail.com>
Date: Fri, 17 Aug 2007 22:56:04 -0700
From: "Mike Mohr" <akihana@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: group ownership of tun devices -- nonfunctional?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Per the post here:

http://lkml.org/lkml/2007/6/18/228

it appears that the group ownership patch has made it into .23.  I am
using these patches, amongst which the kernel component appears to be
identical:

http://sigxcpu.org/unsorted-patches/0001-allow-tun-ownership-by-group.patch
http://sigxcpu.org/unsorted-patches/tunctl_gid.diff

I can create devices that are owned by my user account (tunctl -u
`whoami` -t tap0) and it works fine.  However, if I use group
permissions with -g it stops working.  In all cases, if I pass -g
<group>, the interface is created correctly but it is unusable as a
non-root user.

So my question is: am I doing something wrong?  If I am, I don't see
it.  Assuming then that I am not doing anything wrong on my end, I
assume then that there is something missing from the kernel patch I
applied.  I read over it and I can't see any issues, especially
considering that tunctl comes back without error (even with -g) and
creates an interface.

Just wondering if this was an issue that should be looked into--

Mike
