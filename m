Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbXIYRv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbXIYRv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 13:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbXIYRvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 13:51:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:7864 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbXIYRvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:51:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LyN/A/b5qNqBVRW01aWO6mYfAkWiBnzIugfGx8Nc8oE69Pk5d/gzJVMvPyLr9TuTtXcTl5OPxTzcHko85Tah1MemSPrCvGdMtBZA1E+LRvNGubAxcvscD1lh6h4Yp3D8eBnnT2QXHaNwGvI4RVOkdabss0HHavYsK5ORfrUlfnk=
Message-ID: <d120d5000709251051n45e415e6gbdd87a98f0b8cdd4@mail.gmail.com>
Date: Tue, 25 Sep 2007 13:51:19 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Michael Guntsche" <mike@it-loops.com>
Subject: Re: 2.6.23 /proc/bus/input/devices content question
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <6D36DFB9-B26D-4CEA-B7AD-0216F7124FC5@it-loops.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6D36DFB9-B26D-4CEA-B7AD-0216F7124FC5@it-loops.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On 9/25/07, Michael Guntsche <mike@it-loops.com> wrote:
> Hi,
>
> After upgrading to 2.6.23-rc7 for testing purposes I noticed that the
> contents of /proc/bus/input/devices changed a little bit.
>
> I now have the following entries for my USB-keyboard
>
> ....
> P: Phys=usb-0000:00:1d.0-2/input0
> S: Sysfs=/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/input/input2
> ....
>
> with kernel < 2.6.23 I saw
>
> ....
> P: Phys=/input0
> S: Sysfs=/class/input/input0
> ....
>
> I this a "wanted" change or should I still see the same with 2.6.23?
>

Is this with CONFIG_SYSFS_DEPRECATED=y?

-- 
Dmitry
