Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbYGIA7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbYGIA7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 20:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYGIA7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 20:59:44 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:45123 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbYGIA7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 20:59:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Tkro4RuvLGDejVMjyVwavr3E3T+nBvNYBPI4wWzRqHkyCeK15U5BJjngFx2MT49i7D
         3kOOrznv5jmP/bq9kKhphS2O+UXrcC4+nC+W9xceBMKRgI0iHTiSjXe6+lngx+RcySLc
         m5wOMmE6irm4uJwGzcieSkCwPw9ib3d8fNIUM=
Message-ID: <86802c440807081759i3baafa9bj7e8ff544a1a78fb9@mail.gmail.com>
Date: Tue, 8 Jul 2008 17:59:39 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Suresh Siddha" <suresh.b.siddha@intel.com>
Subject: Re: [patch] tip/x86_64: fix e820 merge issue which broke max_pfn_mapped
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080708230837.GD1678@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080708230837.GD1678@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2008 at 4:08 PM, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> With out this 64bit tip/master doesn't boot using ACPI on my system.
> ---
>
> max_pfn_mapped should include all e820 entries.
> The direct mapping extends to max_pfn_mapped, so that we can directly access
> apertures, ACPI and other tables without having to play with fixmaps.
>
> With this, my system with 1GB memory boots fine with ACPI enabled.

so without this patch, your system doesn't boot?

YH
