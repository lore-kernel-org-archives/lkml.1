Return-Path: <linux-kernel-owner+w=401wt.eu-S1758816AbYE0SGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816AbYE0SGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 14:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756925AbYE0SG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 14:06:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:14980 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670AbYE0SG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 14:06:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VPoP0ETqO1z9cesXqHifsrhbmBZiP8Fhlz7tOfo24qJMtQjyrNW/VMxY/kphFGCEZeVtmmGqiDLrejLR+Fj5hmVdHDEbZsjzWw+fhDlMiU8NPfS4yjLKv9sy6QwL1CfjdIE3MyLd+Yo1VIdPlaC4FqO3boBJGYLtmNsibzftIq0=
Message-ID: <cd73a99e0805271106n173dc05bk49748f112c602847@mail.gmail.com>
Date: Tue, 27 May 2008 20:06:25 +0200
From: "Andrew Victor" <avictor.za@gmail.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH] atmel_serial: Filter out FP during baud rate detection
Cc: akpm@linux-foundation.org, linux@maxim.org.za,
       linux-kernel@vger.kernel.org
In-Reply-To: <1211894683-20934-1-git-send-email-haavard.skinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1211894683-20934-1-git-send-email-haavard.skinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Haavard,

> I made a change to u-boot that used the FP (Fractional Part) field of
> BRGR to achieve more accurate baud rate generation. Unfortunately, the
> atmel_serial driver looks at the whole BRGR register when trying to
> detect the baud rate that the port is currently running at, so setting
> FP to a nonzero value breaks the baud rate detection.

> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Acked-by: Andrew Victor <linux@maxim.org.za>

The FP (Fractional Part) is not supported on some AT91 processors
(RM9200, SAM9261) though.
Those bits in BRGR are undefined.


Regards,
  Andrew Victor
