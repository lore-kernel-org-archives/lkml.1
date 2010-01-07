Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533Ab0AGWpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0AGWpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:45:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240Ab0AGWpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:45:05 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:63361 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab0AGWpE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 17:45:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=c3cx/AopQamG0he7Pj7F59RLCmIDgX8LMeZbswZsBs+oSqXc3kbNjeJJaKqlthyxi9
         V4QwwPtkzq2Qb1wlEcOyip8UJcmM8XQ8N/6gTM7vNo53R26hqmTRoVZp04VCZ2Zt/r2A
         2Y2bkodVvtyXpJiwkhlbHuNb5HKKmthHyuce0=
MIME-Version: 1.0
In-Reply-To: <20100107212912.GB10344@brick.ozlabs.ibm.com>
References: <1262882447-23776-1-git-send-email-a.beregalov@gmail.com>
	 <20100107212912.GB10344@brick.ozlabs.ibm.com>
Date: Fri, 8 Jan 2010 01:44:59 +0300
Message-ID: <a4423d671001071444k2cb61c0blb1bb175ab0098a9f@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf: add close()/closedir() calls when needed
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/8 Paul Mackerras <paulus@samba.org>:
> On Thu, Jan 07, 2010 at 07:40:46PM +0300, Alexander Beregalov wrote:
>
>> Close file and directory descriptors before exiting or dying.
>
> Your patch description doesn't say why that's a good thing to do, and
> it's not obvious to me at least.  Please explain the motivation in
> your patch description.

Isn't it a good style to close files after use and before exit?
