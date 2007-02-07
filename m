Return-Path: <linux-kernel-owner+w=401wt.eu-S1030448AbXBGAZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030448AbXBGAZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 19:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030447AbXBGAZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 19:25:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:41178 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030448AbXBGAZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 19:25:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BjejMFWqyFeXZ2x7gJfqVwa7w2esSjG1zOWTcHjWrUfuFzBtNHOc1viPE9w1WmjBE16Du8Lp07HPObXZg2nSndKAZtkAWqDQsZQK3TU3DUUwXLV+Lv/4BpmYCNcTrMm2VbBaT5nKr4rGa/KDtcL3lfi32TppOvDdm1oT8JP7/ao=
Message-ID: <21d7e9970702061625u24e09305v63c7f9780b02de93@mail.gmail.com>
Date: Wed, 7 Feb 2007 11:25:03 +1100
From: "Dave Airlie" <airlied@gmail.com>
To: landwer@free.fr
Subject: Re: 2.6.20 [drm:i915_wait_irq] *ERROR*
Cc: linux-kernel@vger.kernel.org, dri-devel <dri-devel@lists.sourceforge.net>
In-Reply-To: <1170806926.5669.6.camel@cocoduo>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1170806926.5669.6.camel@cocoduo>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I'm running a 2.6.20 kernel on my macbook. When running an openGL
> application, if the opengl window's region is moved somewhere outside
> the screen limits, then keyboard locks, I can only move the mouse,
> nothing response. I can only reboot the box by pressing the power button
> 5 seconds. /var/log/syslog contains that :
>
> kernel: [drm:i915_wait_irq] *ERROR* i915_wait_irq: EBUSY -- rec: 730561 emitted: 730570
>
> The macbook uses an intel card :
>
> 00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT Express Memory Controller Hub (rev 03)
> 00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS/940GML Express Integrated Graphics Controller (rev 03)
>

I'm cc'ing dri devel in case anyone there knows why this might happen...

Dave.
