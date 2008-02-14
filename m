Return-Path: <linux-kernel-owner+w=401wt.eu-S1762839AbYBNGcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762839AbYBNGcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 01:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbYBNGcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 01:32:06 -0500
Received: from wx-out-0506.google.com ([66.249.82.237]:51430 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbYBNGcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 01:32:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AyTnFh+CNz+OTgexTzSvJpvunVTM6xgqDkiPQJ/yhJNVeDmCVmCnpD0UvL+WPOURbfNv5w43/3x1Xa/4n2P/aBWwG+NbZ6gjFVAhpfZjKcXwAvB0RdGEFEkdGj/ePWT/2qBdJfUAabm2s+A950xfNDJymqvmtew8z8DupQOqpQM=
Message-ID: <86802c440802132232g79fe5eaew3f86e412eeff41a9@mail.gmail.com>
Date: Wed, 13 Feb 2008 22:32:02 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Subject: Re: 2.6.25-rc1 panics on boot
Cc: "Chris Snook" <csnook@redhat.com>, lenb@kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080214062033.GB17151@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080213170310.GC19570@linux.vnet.ibm.com>
	 <47B3322A.2030607@redhat.com>
	 <20080214062033.GB17151@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 10:20 PM, Dhaval Giani
<dhaval@linux.vnet.ibm.com> wrote:
> On Wed, Feb 13, 2008 at 01:08:42PM -0500, Chris Snook wrote:
>  > Dhaval Giani wrote:
>  >> I am getting the following oops on bootup on 2.6.25-rc1
>  > ...
>  >> I am booting using kexec with maxcpus=1. It does not have any problems
>  >> with maxcpus=2 or higher.
>  >
>  > Sounds like another (the same?) kexec cpu numbering bug.  Can you post/link
>  > the entire dmesg from both a cold boot and a kexec boot so we can compare?
>  >
>
>  Don't think its a kexec bug. Get the same on cold boot. dmesg from kexec boot.

how about without "crashkernel=64M@16M nmi_watchdog=2"

also does intel cpu support nmi_watchdog=2?

YH
