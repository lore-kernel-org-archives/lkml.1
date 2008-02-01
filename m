Return-Path: <linux-kernel-owner+w=401wt.eu-S1759682AbYBATQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682AbYBATQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 14:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760267AbYBATPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 14:15:50 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:40250 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760254AbYBATPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 14:15:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=alssys3xiZGAElyVmPaX2qYAta+5dAHGhXn5UyD3hw4lFxGwmRhIQhsGqHXGKrisOPBrMTnvuHZRpDVCU1v6BqEe8zM6vxp191of88UKbTO1jrjb4haLCxVPMMhX/Mi+u0He9OIGzWmAuX1F7fzr1RQlztAZXyJc1y88fAiX7Ck=
Message-ID: <86802c440802011115r2a50d16bgdb0c5e2bc1c8d761@mail.gmail.com>
Date: Fri, 1 Feb 2008 11:15:45 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "dean gaudet" <dean@arctic.org>
Subject: Re: system without RAM on node0 boot fail
Cc: "Christoph Lameter" <clameter@sgi.com>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.00.0802011011080.14726@twinlark.arctic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801302026.27130.yinghai.lu@sun.com>
	 <200801302102.09510.yinghai.lu@sun.com>
	 <Pine.LNX.4.64.0801302049180.15109@schroedinger.engr.sgi.com>
	 <alpine.DEB.1.00.0802011011080.14726@twinlark.arctic.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 1, 2008 10:11 AM, dean gaudet <dean@arctic.org> wrote:
> actually yeah i've seen this... in a bizarre failure situation in a system
> which physically had RAM in the boot node but it was never enumerated for
> the kernel (other nodes had RAM which was enumerated).
>
> so technically there was boot node RAM but the kernel never saw it.

BIOS sometime disabled some dimms on node that it thought that dimm
was bad and caused mce error in last boot.

YH
