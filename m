Return-Path: <linux-kernel-owner+w=401wt.eu-S1761307AbXE3Vuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761307AbXE3Vuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759952AbXE3VtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:49:06 -0400
Received: from mail-gw3.adaptec.com ([216.52.22.36]:36457 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760869AbXE3VtE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:49:04 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: kexec and aacraid broken
Date: Wed, 30 May 2007 17:49:01 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01A551D3@otce2k301.adaptec.com>
In-reply-to: <86802c440705301422h4e1fe90fra5a809cede5903a8@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: kexec and aacraid broken
Thread-Index: AcejAJsEWdL8WchwTqeICaGSGldMzwAAg69A
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <linux-scsi@vger.kernel.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu [mailto:yhlu.kernel@gmail.com] writes:
> aacraid_commit_reset.patch is in the mainline already.

But aacraid_commit_reset.patch is not in 2.6.22-rc3 (to which you report
the issue). Does the aacraid_commit_reset.patch work to resolve this
issue all by itself in the kexec'd kernel? Or alternatively did you try
aacraid.startup_timeout=540 as one of the kernel parameters passed to
the kexec'd kernel?

The '[PATCH] aacraid: fix shutdown handler to also disable interrupts'
patch (you refer to this as patch 4) is not to be in the picture because
it will hide the root cause. I believe I have you correct in stating
that this patch (4) resolves the problem... but I expect the problem to
remain with kdump.

Sincerely -- Mark Salyzyn

