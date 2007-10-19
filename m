Return-Path: <linux-kernel-owner+w=401wt.eu-S936619AbXJSSsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936619AbXJSSsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 14:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936014AbXJSSpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 14:45:42 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:43273 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936359AbXJSSpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 14:45:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=aYQ6ZEYwrs2ZoaRESlkM6QxcFQS7p7KwHj9y8p5EtyBbGuAcczZ4QZMa4MQeDUJw1qvIDcR51VkHuOjaRKDA3/h+u7o8K65JJfpBrmjXm5T8ScYzmvbk28HSYgLVZ6vbUMvqUiMoU91KZH1Bsb8v59pL8I6naKGcESw01xLQ5C0=
Message-ID: <e06186140710191145r4276e974s1218a6325b5a1f9f@mail.gmail.com>
Date: Fri, 19 Oct 2007 12:45:36 -0600
From: "Charles R Harris" <charlesr.harris@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: fix TSC clock source calibration error
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-16 at 10:50 -0400, Dave Johnson wrote:
>
>  range of tsc_khz  # of boots  % of boots
> -----------------  ----------  ----------
>         < 1999750           0      0.000%
> 1999750 - 1999800          21      3.048%
> 1999800 - 1999850         166     24.128%
> 1999850 - 1999900         241     35.029%
> 1999900 - 1999950         211     30.669%
> 1999950 - 2000000          42      6.105%
> 2000000 - 2000000           0      0.000%
> 2000050 - 2000100           0      0.000%
>                    [...]
> 2000100 - 2015000           1      0.145%  << BAD
> 2015000 - 2030000           6      0.872%  << BAD
> 2030000 - 2045000           1      0.145%  << BAD
> 2045000 <                   0      0.000%
>
> The worst boot was 2032.577 Mhz, over 1.5% off!

This may be related to bug
https://bugzilla.redhat.com/show_bug.cgi?id=270321 at Redhat bugzilla.
It has been easily reproducible on my machine.

Chuck
