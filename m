Return-Path: <linux-kernel-owner+w=401wt.eu-S972891AbXHMQig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S972891AbXHMQig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S943064AbXHMPo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:44:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:2934 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S942886AbXHMPox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:44:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kOANs7T6twX3xWlVQtxCz007OQKEG8abr3PZ2qRQBQVGBLxr+7yec70e4x5x60+tBA0hcY1wftK9ehYd1v40uWuMcZ9+QEEEw+9HTIAtWwHsT2Ih8g1Ae4UnJK4Z1TVj56WAP916DNfARh8KN1fHKfLf0nm3AtvaDrKkgF4nkII=
Message-ID: <6bffcb0e0708130844k888bcc9ye06c766d0e1bdcab@mail.gmail.com>
Date: Mon, 13 Aug 2007 17:44:51 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: Unexpected busfree in Message-in phase
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <9a8748490708110810u2c7d6275hbd73cdede58a023d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490708110810u2c7d6275hbd73cdede58a023d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper,

On 11/08/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> Hi,
>
> I just noticed this in dmesg :
>
> [ 3216.262987] (scsi0:A:4:0): Unexpected busfree in Message-in phase
> [ 3216.263058] SEQADDR == 0x16c
> [ 3216.263724]  target0:0:4: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 16)
>
> That's all there is in addition to the normal bootup messages, just
> those 3 lines.
> The machine is doing fine at the moment, no ill effects so far, but an
> explanation of what exactely could be causing that and whether or not
> it is a (fixable) problem would be very nice :-)
>
>
> Some details :
>
> $ scripts/ver_linux
> If some fields are empty or look unusual you may have an old version.
> Compare to the current minimal requirements in Documentation/Changes.
>
> Linux dragon 2.6.22-g1db6178c #1 SMP PREEMPT Sat Jul 14 04:10:50 CEST

Is this a regression? I do not have this commit

git-show 1db6178c
fatal: ambiguous argument '1db6178c': unknown revision or path not in
the working tree.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
