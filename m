Return-Path: <linux-kernel-owner+w=401wt.eu-S965675AbXGSRKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965675AbXGSRKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939777AbXGSRJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:09:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:20890 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965482AbXGSRJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:09:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TPpuVe65+UVwcVjsv6JFy1sNy+MYx26SCGIwrJO+h+yj14bH8Qv6e9RHwDVzcBzxL1pPZQscIjl1L3y8q76MagpoG73ZnfkuPlKXkvSDbL9z03hCBO3NHn7E1Qg2tkBtun2VfX9eYinO32FeLeuEFkQsDBoeLRWNNStXSpATA1s=
Message-ID: <68676e00707191009l690213ffv321f96d831bec683@mail.gmail.com>
Date: Thu, 19 Jul 2007 19:09:22 +0200
From: Luca <kronos.it@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: [kvm-devel] [ANNOUNCE] kvm-30 release
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <469F5F31.2030809@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469F5F31.2030809@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/19/07, Avi Kivity <avi@qumranet.com> wrote:
> Changes from kvm-29:
[...]
> - revert ide enable changes that caused an I/O regression

Not really. Dave is seeing the regression when IDE ports are enabled
and KVM BIOS does enable them.
Reverting the patch allows running another BIOS (e.g. QEMU BIOS) which
doesn't enable the port though.

Luca
As a side note: I'm currently busy with ICWE and tomorrow I'll be
leaving for Rome so I cannot do further tests.
