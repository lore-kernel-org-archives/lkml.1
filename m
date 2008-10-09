Return-Path: <linux-kernel-owner+w=401wt.eu-S1760623AbYJITCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760623AbYJITCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 15:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbYJITCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 15:02:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:8597 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbYJITCX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 15:02:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=JK6Sx+Zdo7dO1WIeQS4b/w3OEzsK51BI+91KX/LcqJSSCcuwnlkZXB6qGuvQS03Pv3
         hpMEwS5agT567kuL15tVtSfUgizA+wbr/HiJQ/JDedMcDSF95k1BrX+ae5pYECph2Ai1
         6jm5dww8KSR3DdUzqC6BjUz4+x2IrvDb8/OBs=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: loading ipmi_watchdog causes tons of other watchdog modules to be loaded
Date: Thu, 9 Oct 2008 21:02:15 +0200
User-Agent: PLD Linux KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <200810091348.19828.a.miskiewicz@gmail.com> <200810091922.24108.a.miskiewicz@gmail.com> <ac3eb2510810091158x3b677959j480c554b86c1ee26@mail.gmail.com>
In-Reply-To: <ac3eb2510810091158x3b677959j480c554b86c1ee26@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810092102.16110.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 October 2008, Kay Sievers wrote:
> On Thu, Oct 9, 2008 at 7:22 PM, Arkadiusz Miskiewicz
>

> > ... but that ipmi_watchdog is the correct driver that handles
> > /dev/watchdog, so this shouldn't be happening, correct?
>
> While the driver you expect to work is loaded, what does:
>   ls -l /dev/watchdog
> print?
>
> If the devno of this node is 10:130, what does:
>   find /sys/class /sys/devices/ -name dev | xargs grep 10:130
> print?

# ls -l /dev/watchdog
crw------- 1 root root 10, 130 sie  8 17:00 /dev/watchdog
# find /sys/class /sys/devices/ -name dev | xargs grep 10:130
/sys/class/misc/watchdog/dev:10:130


> Kay



-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
