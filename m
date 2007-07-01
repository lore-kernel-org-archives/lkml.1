Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbXGAEtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbXGAEtj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 00:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbXGAEtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 00:49:31 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:51359 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbXGAEta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 00:49:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RagCrCAn0qcW7z4JQuSdV0Ah7SoKcT9MLxUxvrEv9VzAH3iqt+Ww3UdrJLtqRyXFWJVhsEM9OpDSznzV1OfEimwdQ8K28wj1uK2rKP/Go+2PLJ/v2k4yUDP1ow3m1lcMcF+kpCYx7hTpmhD2ddnzR4SSsPlakl0vDARPVzrmmqw=
Message-ID: <a781481a0706302149jcaeca33q4f556bcb6193c31d@mail.gmail.com>
Date: Sun, 1 Jul 2007 10:19:29 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "jim miro" <daliroot@yahoo.com>
Subject: Re: kvm_amd: Unknown symbol signal_pending - where should I be looking?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <95403.37043.qm@web39512.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <95403.37043.qm@web39512.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/1/07, jim miro <daliroot@yahoo.com> wrote:
> I am trying to get Kvm running on Debian with a custom
>  2.6.22-rc5 amd dual core kernel.

Custom as in custom (non-mainline) patches? Can't really
help with those, then.

> To prepare I do:
>
> /sbin/modprobe kvm-amd
> FATAL: Error inserting kvm_amd
> (/lib/modules/2.6.22-rc5/extra/kvm-amd.ko): Unknown
> symbol in module, or unknown parameter (see dmesg)
>
> dmesg returns:
> kvm_amd: Unknown symbol signal_pending

signal_pending was supposed to be an inline, and
drivers/kvm/svm.c does #include sched.h ... so not sure
where's the problem.

> lsmod shows:
> kvm                    56996  0

Send your .config, in any case.
