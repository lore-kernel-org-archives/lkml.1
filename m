Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbXFPHVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbXFPHVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 03:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbXFPHVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 03:21:11 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:43470 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbXFPHVK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 03:21:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VA+LjNyx0NCynUIHFhD4Z05QyyLCJ8jPbmJqTUn3YxqKyTnDq1kWIbT5bdj8t7qTGJOcd5pPlNTtZwS9MnalCbb38sWMmIJU7MDDPQaMDfaFN8NBTh0iz12rC2ngJcOpfJbGFBUIZSbpIIGye/G2FFM0KvPse9mpE328Nly7nk0=
Message-ID: <4354d3270706160021m56ee71e2ic4bd4e5da9ecab4@mail.gmail.com>
Date: Sat, 16 Jun 2007 10:21:09 +0300
From: "=?ISO-8859-1?Q?T=F6r=F6k_Edvin?=" <edwintorok@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: CFS Scheduler and real-time tasks
In-Reply-To: <4354d3270705181407t6e2d6der396ea3d0fd06f790@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <4354d3270705171214v25bc4834t5e28a08649761e91@mail.gmail.com>
	 <20070517192343.GA24249@elte.hu>
	 <4354d3270705171310x1d7770b2mb086f1fde7cffabd@mail.gmail.com>
	 <20070517201338.GA1713@elte.hu>
	 <4354d3270705181407t6e2d6der396ea3d0fd06f790@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/19/07, Török Edvin <edwintorok@gmail.com> wrote:
> I tried -v13. However the scheduling "error" is now 10% (vs 2% with -v12).
>
> I also noticed strange behaviour with CPU hotplug. I offlined cpu1
> (echo 0 >/sys/devices/system/cpu/cpu1/online), and the typing speed on
> my terminal decreased noticably. I could hardly type something there.

These both have been fixed in cfs-v17. Smp load balancing is accurate,
and I noticed no problems with CPU hotplug.

Thanks,
Edwin
