Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbXLJJry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbXLJJry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 04:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbXLJJrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 04:47:46 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:63666 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbXLJJrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 04:47:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=C5LYi/12zA5PJprauiC48khdTAi1m3EG7wjo8A64jR1eoOuBSGkWRxwUq/OMBH7KH8UyCqd7cQWchvLP89oAmLe4itsTNZ3DV92Mtjzoo6nUIo/Y/Q11F0RskxNxwe8CB2AUsxcADlu8ZDZJhqsE5MQCM1hh+JhsCUbWnCcUNP0=
Message-ID: <475D0B3A.7000406@gmail.com>
Date: Mon, 10 Dec 2007 18:47:38 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: devzero@web.de
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ata_piix init/performance regression ?
References: <32463620@web.de>
In-Reply-To: <32463620@web.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devzero@web.de wrote:
> Hello !
> 
> on my old fujitsu-siemens lifebook, booting is at least 20 seconds slower as before.
> 
> on ata_piix init i can see 2 longer delays of ~10 seconds each, which didn`t happen before.
> 
> i`m using SuSE kernel of the day from http://ftp.suse.com/pub/projects/kernel/kotd/
> 
> problem exists with these kernels:
> kernel-vanilla-2.6.24_rc3_git3-20071201095839
> kernel-default-2.6.24_rc3_git3-20071201095839
> kernel-default-2.6.24_rc4_git3-20071206172629
> kernel-vanilla-2.6.24_rc4_git3-20071206172629
> 
> problem didn`t exist with this one:
> kernel-default-2.6.22.12-0.1 (opensuse 10.3 default)
> 
> please see https://bugzilla.novell.com/show_bug.cgi?id=345442 for more details.

That's a TSC problem on suse kernel.  I'll follow up on the bugzilla.

-- 
tejun
