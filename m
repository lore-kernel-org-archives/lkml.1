Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbZKPUPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbZKPUPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 15:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbZKPUPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 15:15:55 -0500
Received: from nox.protox.org ([88.191.38.29]:37986 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbZKPUPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 15:15:54 -0500
Subject: Re: drm/ksm -> s2disk -> resume -> [drm:r100_ring_test] *ERROR* 
 radeon: ring test failed (sracth(0x15E4)=0xCAFEDEAD)
From: Jerome Glisse <glisse@freedesktop.org>
To: Christian Hartmann <cornogle@googlemail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <ffd8902a0911060754i3da8ef12n86661537872148fe@mail.gmail.com>
References: <ffd8902a0911060746x4dd818b4v4fc94208823c321b@mail.gmail.com>
	 <ffd8902a0911060754i3da8ef12n86661537872148fe@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Nov 2009 21:15:55 +0100
Message-Id: <1258402555.2031.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-06 at 16:54 +0100, Christian Hartmann wrote:
> hello,
> 
> here the dmesg from boot before resume. the first dmesg was truncated..
> 
> 
> 2009/11/6 Christian Hartmann <cornogle@googlemail.com>:
> > radeon driver is broken after resume, I have to reboot everytime.
> >
> > [  170.805463] [drm:r100_ring_test] *ERROR* radeon: ring test failed
> > (sracth(0x15E4)=0xCAFEDEAD)
> > [  170.805471] [drm:r100_cp_init] *ERROR* radeon: cp isn't working (-22).
> >
> > Could it be (Im am really not sure yet), that i have included the
> > firmware R100_cp.bin into the kernel space?
> yes, I have included it. But ...
> > ...why is this not working after a normal resume?
> 
> me again, chris h.

Can you confirm that booting the kernel with radeon.agpmode=-1 fix your
issue ? My guess is that once again AGP is broken on resume, we have
several issue with evil AGP.

Cheers,
Jerome



