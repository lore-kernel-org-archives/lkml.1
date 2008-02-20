Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbYBTH2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbYBTH2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 02:28:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750834AbYBTH1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 02:27:52 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:38017 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbYBTH1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 02:27:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=joNUXtsbeBzQWZNYT1YVxsTS8MUVcqItAyBYWj293/M/HB5i6GL2xZnTxNcUXilC+6ImLKjM3KxKjyvP2YXe7xG7E/EEaWMLeR469e2vcpBaR81p5uSNLDgZ3QAPqdiN4w+dfF3xvyMr0FSWUlgtdjYnLICZZaAkY/l7mRlvbvg=
Message-ID: <e2e108260802192327v124a841dnc7d9b1c7e9057545@mail.gmail.com>
Date: Wed, 20 Feb 2008 08:27:48 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Oliver Pinter" <oliver.pntr@gmail.com>
Subject: Re: SMP-related kernel memory leak
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <6101e8c40802191018t668faf3avba9beeff34f7f853@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e2e108260802190300k5b0f60f6tbb4f54997caf4c4e@mail.gmail.com>
	 <6101e8c40802191018t668faf3avba9beeff34f7f853@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 19, 2008 7:18 PM, Oliver Pinter <oliver.pntr@gmail.com> wrote:
> On 2/19/08, Bart Van Assche <bart.vanassche@gmail.com> wrote:
> > I noticed that the amount of memory used by the Linux kernel steadily
> > increases over time on SMP systems (x86 architecture, 32-bit kernel).
> > This problem disappears when I add maxcpus=1 to the kernel command
> > line. I have observed this behavior both on the 2.6.22.18 and 2.6.24.2
> > kernels. Did anyone notice anything similar ?
> >
> > See also: http://bugzilla.kernel.org/show_bug.cgi?id=9991
>
> this patch fixed them http://lkml.org/lkml/2008/2/18/405 ?

Thanks for the hint. If I interpreted the 2.6.24 changelog correctly
this patch is already included with 2.6.24 ? The problem still occurs
with 2.6.24.2. I am currently trying to find the minimal kernel config
which still triggers this problem. Any other hints for finding the
cause of this issue are welcome of course.

Bart Van Assche.
