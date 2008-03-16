Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbYCPSM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbYCPSM1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 14:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYCPSMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 14:12:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:40020 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYCPSMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 14:12:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=LNCnWzNEmqA+pjXsezLftuZp/T41kuj574CS6m7DNspq1vbTQuoPARHG5vMMCiOCIiMQqymsO72r/hLqgqmmTjioM5wQQO2GAUTgQH1blamQoxSBn2mDi5aUbj4wlEcIPBJCGYeTjgjDM71iJgobu5hZiv7EjVaQWTvHS5uwe4Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.25-rc4
Date: Sun, 16 Mar 2008 19:26:35 +0100
User-Agent: KMail/1.9.9
Cc: Anders Eriksson <aeriksson@fastmail.fm>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <alpine.LFD.1.00.0803160924580.3020@woody.linux-foundation.org> <200803161907.04581.bzolnier@gmail.com>
In-Reply-To: <200803161907.04581.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803161926.36169.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 March 2008, Bartlomiej Zolnierkiewicz wrote:

[...]

> I think that we are looking into completely wrong direction...

Alt-SysRq-T traces that Anders posted shows that the system hangs inside
block layer, if not clearing DRQ would be the case we should see system
getting stuck inside IDE (or at least IDE commands timing out)...

I really do think that it is the same hang-in-block-layer issue that
Ingo managed to hit once (his system was using libata)...

Thanks,
Bart
