Return-Path: <linux-kernel-owner+w=401wt.eu-S1752247AbZGOG0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbZGOG0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 02:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZGOG0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 02:26:32 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:39354 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbZGOG0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 02:26:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kkpM8qLnkulczdoXkK8qyGCzE7dckJGrPSRl+brLpg1lRlogWTBu6/M+l94jmj3GvI
         qBErAeDf1/j+Kf5qhiy1BLODFeeDeUDkdOghIreHt6aQ7a1hXMabUdtlf2M0kaAPzUhj
         nnbhYxwDUam322Xb8nig45fOwq3vPuDO1U3RU=
MIME-Version: 1.0
In-Reply-To: <7a7c22420907142137o4253dfb5gcd72176cd6a38beb@mail.gmail.com>
References: <7a7c22420907142137o4253dfb5gcd72176cd6a38beb@mail.gmail.com>
Date: Wed, 15 Jul 2009 11:56:30 +0530
Message-ID: <7a7c22420907142326t3b8d4f5fqaf3813cb456186ec@mail.gmail.com>
Subject: Re: SCSI command (SP-OUT) failing on SLES 9 32-bit
From: rohan a <info1686@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I do not want to move to the SG3 driver as of now since all devices
are working on all Linux platforms using the deprectaed SG driver.



On 7/15/09, rohan a <info1686@gmail.com> wrote:
> Hello,
>        The SCSI command for LTO-4 drive based encryption (SPOUT
> opcode = 0xB5) is failing on SLES 9 32-bit only and not on SLES 9 (64-
> bit), SLES 10,11 or RHEL 4/5
>
> Any idea why this is happening?
>
> Error returned is : Invalid field in CDB
>
> I am using ioctl() with the deprecated request SCSI_IOCTL_SEND_COMMAND
> and not the SG3 driver.
> However, only the SPOUT command is failing and none of the other SCSI
> commands.
> For ex: even the SPIN command (to obtain encryption status and
> capabilities) works.
>
> I even updated to SP4.
>
> Any suggestions here?
>
> Thanks
>
