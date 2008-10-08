Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbYJHXwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbYJHXwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 19:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbYJHXwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 19:52:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:41870 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898AbYJHXwd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 19:52:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=XztzF1gtvKvSI5KDPst3ilJJ8SQCB3T4Y9tsqDBeqAWOrMh0+ewE1zxhhcktkyOb+I
         CFinvoeD/ZoTNWNC/Z2bR/JV+5mFjoAEzP4Ns6ftdOttSNVBHo0fG3Rb4n8IBzMpoCLM
         TyzWw1mvYxGa9HEJ/W1SzkUQsVgX7pq505wC0=
Date: Thu, 9 Oct 2008 01:52:40 +0200
From: dcg <diegocg@gmail.com>
To: "Ping Cheng" <pingc@wacom.com>
Cc: <dmitry.torokhov@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: Wacom tablet not working with 2.6.27-rc: kernel or X.org driver
 fault?
Message-ID: <20081009015240.7f935fdc@diego-desktop>
In-Reply-To: <6753EB6004AFF34FAA275742C104F95271BCC8@wacom-nt10.wacom.com>
References: <20081008231131.4feb01cd@diego-desktop>
 <6753EB6004AFF34FAA275742C104F95271BCC8@wacom-nt10.wacom.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, 8 Oct 2008 15:42:11 -0700, "Ping Cheng" <pingc@wacom.com> escribió:

> The bug with ubuntu is related to kernel 2.6.26 and the user's newer
> tablet.  They have to upgrade wacom.ko from linuxwacom themselves or
> wait for ubuntu to do the job for them.  That has nothing to do with
> kernel.org.

Well, it's not just a matter of newer tablets, the bug reported in ubuntu
is from a user with a tablet which worked with the kernel included
in ubuntu, which does not include any patch to the wacom's kernel
driver, and X.org 7.3, and stopped working properly (ie, it "works", but
click events don't work, and the pointer does weird things) installing
X.org 7.4 (just like my wacom bamboo tablet). A newer version of X.org
driver should not stop working with the devices and kernel.org drivers
it used to work before.

Now that I'm looking at it, the xserver-xorg-input-wacom ubuntu package
is not compiled from X.org 7.4, but from linuxwacom.sf.net sources, and
is using the version 0.8.1.4, IOW, the -dev branch of linuxwacom.sf.net.
So maybe the problem is that there's a bug in the -dev branch of
linuxwacom, but in any case it should get fixed ASAP, as many people is
going to hit this problem...
