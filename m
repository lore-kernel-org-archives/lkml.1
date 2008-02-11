Return-Path: <linux-kernel-owner+w=401wt.eu-S1760972AbYBKThw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972AbYBKThw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757088AbYBKThn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:37:43 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:33289 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757911AbYBKThl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:37:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=mk1xbpm8JOxYJFWEkyD44O6x9Ro6R0JLQK74ouVngWnam21/rjnjrFfjpdZ+4G/BXHQ8Ddhprdb0nSVvPhpQzo1c9mZvouxrnrZ+N1Y89eJsusvvioGKNOgxkXApEhd8FAOpGzTc+BjNVnYUZw3I69Wm1w9tz6moQD3ubwNXmGo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: webmaster@dragonslave.de
Subject: Re: 2.6.25 Regression: DriveStatusError
Date: Mon, 11 Feb 2008 20:51:45 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200802110927.36109.dex@dragonslave.de>
In-Reply-To: <200802110927.36109.dex@dragonslave.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802112051.45395.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday 11 February 2008, Daniel Exner wrote:
> Hi!
> 
> Please CC me as I'm not subscribed to any list, thx in advance.
> 
> I tried all -git Kernels since begining of cycle and starting when they finaly 
> compiled fine, they weren't able to mount my root.
> 
> As my laptop with the serial cable is on the run currently I wasn't able to 
> get a trace (perhaps by the we) but error written by hand from screen was 
> this:
> 
> hda: task_no_data_intr: status=0x51 {DriveReady SeekComplete Error}
> hda: task_no_data_intr: error=0x04 {DriveStatusError}
> failed opcode was: 0xe1

[...]

Could you please try 2.6.25-rc1-git1:

http://kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.25-rc1-git1.bz2

Thanks,
Bart
