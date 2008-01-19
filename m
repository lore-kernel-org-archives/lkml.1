Return-Path: <linux-kernel-owner+w=401wt.eu-S1760979AbYASOIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760979AbYASOIv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 09:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756733AbYASOIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 09:08:34 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:38890 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272AbYASOId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 09:08:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=h0yYnLaCG2vvC36Gz8HwJWWFV1DTTez15eDqYa74DhNK19F0uJ+KP15TNDt+3n4Vk+0mCHmSucm+tey02h9cd58jKqcBV+GN1uR1RDVOIAzEWPSZRELZ90Sxej1dXFPPtA40p01WpWGx5UqavytB9Vc7YTYY07GBwNG1LnzNMu4=
Message-ID: <ee3dc96c0801190608q33aee0aer133611a1fc392bb4@mail.gmail.com>
Date: Sat, 19 Jan 2008 11:08:32 -0300
From: "Rafael Sisto" <rafael.sisto@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: new file in kernel.
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0801191448140.27831@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ee3dc96c0801190542u2f91a2eax3bcfd0268d4850b4@mail.gmail.com>
	 <Pine.LNX.4.64.0801191448140.27831@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jan,
I had already read that webpage, but I dont need to change the data on
that file. I just want to create a new file and then close it, so I
can use it later in another system call, to mmap it to a user space.
Is it clearer now?
Can you please give me some code snippet?

Thanks again in advance and greetings!
Rafael Sisto.

(Jan, Sorry for the last mail, I answered to your personal mail only)


On Jan 19, 2008 10:49 AM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Jan 19 2008 10:42, Rafael Sisto wrote:
> >Dear forum,
> >can anybody help me with this issue?
> >
> >How do I create a new file in kernel mode?
> >I am trying to create a file in a system call I am building.
>
> http://kernelnewbies.org/FAQ/WhyWritingFilesFromKernelIsBad
>
> Even then, you are a bit too unspecific. A syscall could
> very well call a filesystem's create function and create
> a file that way, though it is a very different use-case.
>
