Return-Path: <linux-kernel-owner+w=401wt.eu-S1030297AbXCMMUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030297AbXCMMUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 08:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965719AbXCMMUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 08:20:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:35039 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965702AbXCMMUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 08:20:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=N16h3QSoqf9S4O+iQ9yzyL3FYbb0GlVjD2fYZVdi9krIfYc01ovz3r3hag1KHSPXoBtnNq0aBQg5s+OJWN/MprpmiYcTT50rsRIvqps/i4XB3MkdSQI+Ll2XfdtL5ZqVhtfNW/vGxMNUI4mRDe3NX7bQBMRNgi/RNlJc0H3glio=
Message-ID: <45F696EC.6050601@gmail.com>
Date: Tue, 13 Mar 2007 21:19:56 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: l.genoni@oltrelinux.com
CC: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: IDE disk runs just in DMA/33 with 2.6.20.2 on nVidia CK804 controller
References: <Pine.LNX.4.64.0703131125270.24498@Phoenix.oltrelinux.com>
In-Reply-To: <Pine.LNX.4.64.0703131125270.24498@Phoenix.oltrelinux.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

l.genoni@oltrelinux.com wrote:
> Hi,
> I reported this also for 2.6.20 kernel.
> new libata with controller nVidia CK804 initializes the disk in DMA/33,
> with with 2.6.19.5 and previous the disk is correctly inizialized in
> DMA/100.
> Tha cable is OK, and with older kernels the disks runs without troubles.
> 
> The sistem has two sata disks on nvidia CK804 controllers, and then a
> disk as primary master, and a dvd writer (DMA/33) as secondary master)

Cable detection on CK804 is basically broken at the moment.  It should
be fixed with Alan's acpi cable detection magic soon (maybe 2.6.21).

Thanks.

-- 
tejun
