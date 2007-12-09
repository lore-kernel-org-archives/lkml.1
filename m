Return-Path: <linux-kernel-owner+w=401wt.eu-S1753603AbXLIJaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbXLIJaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 04:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbXLIJaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 04:30:30 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:56430 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbXLIJa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 04:30:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=u9vWXjMZXYQ/Di80MhCtk2fqhQ/MwmCTOODcRcUZqOieTCyw+IW+c75VBFMTc8+mb7X0eAiXAuNbgDIIfsN/D/O2oHRMoEbZVebZXTCQlP+psc3ZBFEwyMtSkfIv0w4nVEMVEVkJIK0P7/MmQkHSlXLcmOWjFCmx8J8FhUbBP4w=
Message-ID: <475BB5AE.40503@gmail.com>
Date: Sun, 09 Dec 2007 18:30:22 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       rusty@rustcorp.com.au, kay.sievers@vrfy.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] depmod: sort output according to modules.order, take
 #2
References: <475936CE.70703@gmail.com> <4759379D.8090201@gmail.com>
In-Reply-To: <4759379D.8090201@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Kbuild now generates and installs modules.order along with modules.
> This patch updates depmod such that it sorts module list according to
> the file before generating output files.  Modules which aren't on
> modules.order are put after modules which are ordered by
> modules.order.
> 
> This makes modprobe to prioritize modules according to kernel
> Makefile's just as built-in modules are link-ordered by them.
> 
> This patch is against module-init-tools 3.3-pre1.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Bill Nottingham <notting@redhat.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Kay Sievers <kay.sievers@vrfy.org>

The kernel part is in now.  Rusty Russell, what do you think about this
depmod change?

Thanks.

-- 
tejun
