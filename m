Return-Path: <linux-kernel-owner+w=401wt.eu-S1760278AbYJIRWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760278AbYJIRWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 13:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755042AbYJIRWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 13:22:30 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:8912 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbYJIRW3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 13:22:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Wf6Y4keS6oFMt//76z9zYwhFVyNtKuILk1+rAfJ+2QjCvLvXyy955FjGY5Yl1Gvsru
         i6LplXyXFC8jyacbF0inSbPDF3BJqBLzYleb891nx2qTmUKH/77g2nI7uLelAAFpgCN2
         BPupzRPCbC7JTSsURZiGsJUgQO97MKHilHOGA=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: loading ipmi_watchdog causes tons of other watchdog modules to be loaded
Date: Thu, 9 Oct 2008 19:22:23 +0200
User-Agent: PLD Linux KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <200810091348.19828.a.miskiewicz@gmail.com> <ac3eb2510810090636w51e04a7fxfa36d8b016b236d@mail.gmail.com>
In-Reply-To: <ac3eb2510810090636w51e04a7fxfa36d8b016b236d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810091922.24108.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 October 2008, Kay Sievers wrote:
> On Thu, Oct 9, 2008 at 1:48 PM, Arkadiusz Miskiewicz
>
> <a.miskiewicz@gmail.com> wrote:
> > No udev on the system. kernel 2.6.25.18-1.
> >
> > After loading ipmi_watchdog and doing "cat /dev/watchdog" tons of other,
> > useles, watchdog modules is loaded. Any idea what introduced such weird
> > behaviour?
>
> I guess the /proc/sys/kernel/modprobe, which lets the kernel fork a
> modprobe process when you touch a "dangling" device node, which does
> not have corresponding driver.

... but that ipmi_watchdog is the correct driver that handles /dev/watchdog, 
so this shouldn't be happening, correct?

> Kay

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
