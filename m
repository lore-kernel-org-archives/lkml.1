Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbZLUOVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbZLUOVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 09:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZLUOVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 09:21:32 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:42429 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbZLUOVb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 09:21:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=H62oaTyUWWd3Oy1CNsl2IZi/yiKiqLUQFSP8AxFOb21kAOoeKiJoJ7MHRe6zFtu6LG
         ic5cGROGpGmMSG4q4kVTlQkoK/7C6GYs7Ml/dfJ+KIK7DinwEiEHr6FyyeufbmhIu3e2
         Glc6G5poIc8bLT0ZJmPxTPRr6u+edfQSiZNaM=
MIME-Version: 1.0
In-Reply-To: <4A5CD77C.6070701@garzik.org>
References: <1247593187-26570-1-git-send-email-vapier@gentoo.org> 
	<4A5CD77C.6070701@garzik.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 21 Dec 2009 09:21:03 -0500
Message-ID: <8bd0f97a0912210621g19535a03q38b8b67c01df6a75@mail.gmail.com>
Subject: Re: [PATCH] libata: pata_bf54x: handle portmuxing of pins through 
	GPIO PORTs
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <cooloney@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 14:07, Jeff Garzik wrote:
> Mike Frysinger wrote:
>> By default, the PATA pins are routed to the async address lines in which
>> case, no peripheral muxing needs to be done.  However, if the pins get
>> routed through the GPIO PORTs pins, we need to make sure to request them
>> so that the muxing is properly set up.
>> ---
>> Andrew: could you pick this up ?  it was posted over a month ago to the
>> Linux/IDE list w/no feedback.
>
> Although it is disappointing that your patch was missed -- our apologies --
> I don't think the best response was to elide linux-ide and the libata
> maintainer, in favor of a higher noise list.  :)
>
> I have the patch queued, now.

so it's been 8 months since it was posted, 6 months since it was
queued, and multiple libata merges have been made, but this patch has
yet to make it into mainline ...
-mike
