Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbYFOKm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbYFOKm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 06:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756966AbYFOKmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 06:42:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:1911 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654AbYFOKmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 06:42:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HHNc4VYvivOrVPjtu5dcN6grmqzcG4rm3eeVp+wHb/F0axvIyFpqyANlyxHc9b9lQe
         6r+vP+ZWaIF7fqVYA+Xw4Eum7OUwPR29G/QKt3LbUUCMhoPyyp82SEmeq0hA0C8b99Ym
         Lb8VmtNVlIch+RRLHx91m5PJv5M/TIzq/8WQE=
Message-ID: <3877989d0806150342r5e5c6a0fy699dc4a8180d9b28@mail.gmail.com>
Date: Sun, 15 Jun 2008 18:42:49 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Bernhard Walle" <bwalle@suse.de>
Subject: Re: kdump regression: /proc/vmcore is 0 after kdump
Cc: LKML <linux-kernel@vger.kernel.org>, andrew.patterson@hp.com,
       "Petr Tesarik" <ptesarik@suse.cz>, "Simon Horman" <horms@verge.net.au>,
       linux-ia64@vger.kernel.org,
       "Kexec Mailing List" <kexec@lists.infradead.org>,
       "Roland McGrath" <roland@redhat.com>
In-Reply-To: <20080615115553.594e4ad7@kopernikus.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3877989d0806050058u3159e7b5x3113f63b3e0f3d8f@mail.gmail.com>
	 <20080605081633.GA6713@verge.net.au>
	 <3877989d0806130922p1f36a3bes9914144ac8c42266@mail.gmail.com>
	 <3877989d0806150226x62fc1d1bk96131430f55848e1@mail.gmail.com>
	 <20080615115553.594e4ad7@kopernikus.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2008 at 5:55 PM, Bernhard Walle <bwalle@suse.de> wrote:
> * "Luming Yu" <luming.yu@gmail.com> [2008-06-15 17:26]:
>>
>> My git bisection result indicates the following commit causes the
>> kdump regression in 2.6.25-rc1:
>> commit 3c75e23784e6ed5f4841de43d0750fd9b37bafcb
>> Author: Andrew Patterson <andrew.patterson@hp.com>
>> Date:   Tue Jan 22 17:18:27 2008 -0700
>
> Can you verify that reverting that commit indeed fixes kdump at your
> site?

I've tested and can confirm reverting this commit resolves crash-boot
hang problem on my Coldfusion box. --Luming
