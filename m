Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbYKUR0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbYKUR0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbYKUR0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:26:04 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:8861 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbYKUR0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:26:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qoYEHgBR3W/EvS/KGGE39qZjVQRSR/E9eNvCwCm8c0k5NcXmwH6aeodU341a2ampOZ
         jPzboXWYueTna7vUboM3ZQ0rvk3my+QhOrGmkUK8xfAXIGb0K5U3RPbTCyCKjXV5+Jbo
         qcneZq/IjB/oxvS6+6Ao3NWNMI5fY1HLzSQ5k=
Message-ID: <df9815e70811210926x28bfc368xb54298dd6b7ddd83@mail.gmail.com>
Date: Sat, 22 Nov 2008 01:26:00 +0800
From: "Jike Song" <albcamus@gmail.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: system fails to boot
Cc: "Jens Axboe" <jens.axboe@oracle.com>, tj@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, pjones@redhat.com,
       alex.shi@intel.com
In-Reply-To: <1226639781.2866.77.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226639781.2866.77.camel@ymzhang>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 1:16 PM, Zhang, Yanmin
<yanmin_zhang@linux.intel.com> wrote:
> Jens,
>
> We run into system boot failure with kernel 2.6.28-rc. We found it on a couple of
> machines, including T61 notebook, nehalem machine, and another HPC NX6325 notebook.
> All the machines use FedoraCore 8 or FedoraCore 9. With kernel prior to 2.6.28-rc,
> system boot doesn't fail.
>
> I debug it and locate the root cause. Pls. see
> http://bugzilla.kernel.org/show_bug.cgi?id=11899
> https://bugzilla.redhat.com/show_bug.cgi?id=471517
>

Hi Yanmin,

It seems I still have this problem with -rc6, both root=LABEL and
root=/dev/sda8.  I have replaced my nash/mkinitrd with patched ones.

Maybe a different issue just with the same appearance? Can you boot
-rc6 smothly on your T61?

--
Thanks,
Jike
