Return-Path: <linux-kernel-owner+w=401wt.eu-S1765570AbYAaIrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765570AbYAaIrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 03:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbYAaIrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 03:47:31 -0500
Received: from hs-out-0708.google.com ([64.233.178.244]:53425 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754815AbYAaIra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 03:47:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p5HhXVRzkpV5ftpL8ZmUEse2V4MR/jnjguLceEuVo+sKF77K0VFMq3frsCLGYaVO8EGX7/yXelwTHFnwoh+l5XcK08aoHFqq/7uIaFhDqroG79uaavWLlTOOUQ9iuQkOZv6pF6x+JGczd59B01zYtVgbra5oJ4IuelTQwcfqMw4=
Message-ID: <a8e1da0801310046q289ce4a1qd8d9f8865e2e6972@mail.gmail.com>
Date: Thu, 31 Jan 2008 16:46:35 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: [BUG] io-scheduler : spinlock deadlock
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080131084526.GJ15220@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080131084345.GA3902@darkstar.te-china.tietoenator.com>
	 <20080131084526.GJ15220@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 31, 2008 4:45 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
>
> On Thu, Jan 31 2008, Dave Young wrote:
> > While building kernel, lockdep detected spinlock deaklock and after a
> > while the system hung.
> >
> > Attached is the screenshot.
>
> Fixed by commit 149a051f82d2b3860fe32fa182dbc83a66274894 yesterday, just
> updated your kernel.

Thanks.

>
> --
> Jens Axboe
>
>
