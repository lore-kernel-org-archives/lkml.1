Return-Path: <linux-kernel-owner+w=401wt.eu-S1758817AbYHUVvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbYHUVvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbYHUVvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:51:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:31509 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbYHUVvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:51:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HbzD3bt2kPNTUEtV+zPWJzPnwJMkidJyaslqSJhJ4VvHIuBlLlwJ0PWAEfWItaA0/+
         BN8s2iRRMV9JHegk66IIGj53mFCkiwNUdZm4YEf2gvm3RDBwHJY7BPDPD8obyntz2Gg4
         bSoVUqrv9tWnUiBMbgnou9ENHI45ZCZlXHdLk=
Message-ID: <86802c440808211451u4483f88ft845cd20c3f23c53a@mail.gmail.com>
Date: Thu, 21 Aug 2008 14:51:43 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Joshua Hoblitt" <josh@hoblitt.com>
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of 16gb of memory is usable
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com
In-Reply-To: <20080821205558.GC23377@hoblitt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bug-11388-27@http.bugzilla.kernel.org/>
	 <20080820180405.7f164450.akpm@linux-foundation.org>
	 <86802c440808201820w6c684a10y2f1d0f70a344a14a@mail.gmail.com>
	 <86802c440808201849k6665c395x5a5b871eca55addd@mail.gmail.com>
	 <20080821205558.GC23377@hoblitt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 1:55 PM, Joshua Hoblitt <josh@hoblitt.com> wrote:
> Both hunks in the patch applied with an offset of -36 but the show_msr
> flag doesn't seem to have any effect.  The dmesg is still the same
> number of lines accord to wc.
>
> I'm attaching the new dmesg anyways.
>
> $ cat /proc/cmdline
> root=/dev/ram0 real_root=/dev/sda3 init=/linuxrc show_msr=1 console=tty0
> console=ttyS0,115200n8

can you check that with tip/master?

http://people.redhat.com/mingo/tip.git/readme.txt

YH
