Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbXLDRP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbXLDRP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 12:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbXLDRPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 12:15:48 -0500
Received: from nz-out-0506.google.com ([64.233.162.232]:33830 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbXLDRPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 12:15:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rAB/jioxe3yOmlQdD3ebzHZf6Xlu8kfE9Q4vz5wahie5iS4itXtAlSk1BMUftP84/7g5WJBfNMNnOQgTjfr0sKowsvVbnDfY0qPImYNCB9e9cH6KFU9MLnPxackuV8RvDZLv5I/H13ppyGWBr4wsOvl7K9wG2lqbVnSaljvpdUY=
Message-ID: <8bd0f97a0712040915p22117ba8w497e01edc9506507@mail.gmail.com>
Date: Tue, 4 Dec 2007 12:15:46 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Alessandro Zummo" <alessandro.zummo@towertech.it>
Subject: Re: [rtc-linux] Re: [PATCH 1/7] Blackfin RTC driver: the frequency function is in units of Hz, not units of seconds, so lock our driver down to 1 Hz
Cc: rtc-linux@googlegroups.com, "Bryan Wu" <bryan.wu@analog.com>,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       "Mike Frysinger" <michael.frysinger@analog.com>
In-Reply-To: <20071204174146.19bedb54@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1195812512-25979-1-git-send-email-bryan.wu@analog.com>
	 <1195812512-25979-2-git-send-email-bryan.wu@analog.com>
	 <20071204172634.50492e1e@i1501.lan.towertech.it>
	 <8bd0f97a0712040829i116496deu384453c6eccfa252@mail.gmail.com>
	 <20071204174146.19bedb54@i1501.lan.towertech.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 4, 2007 11:41 AM, Alessandro Zummo <alessandro.zummo@towertech.it> wrote:
>  it should be EINVAL. at least it is wat rtc-cmos does when the value
>  is invalid.

in the example rtc test code (Documentation/rtc.txt), would it be
useful to handle EINVAL ?  if the freq isnt supported, just say
"hardware does not support frequency %i" and continue on to try the
next freq ?  the current code just does:
perror("RTC_IRQP_SET ioctl");
exit(errno);
-mike
