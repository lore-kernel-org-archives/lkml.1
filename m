Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbYL2LLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbYL2LLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 06:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbYL2LLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 06:11:12 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:29356 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbYL2LLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 06:11:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EThmaZcr+lX7ziHu247ilX94QBMA+psRknW9FYOPUJdhcb8whoAUj4J7Ogf/JdsQap
         3dNjHpl563EAQsOAe3BMMqme/fM9tnbr18cY2RFSrm45K3UjQgzTUtETNUWHci/tb9Hk
         kCDqCzU38XLEVr/Ee4ko/E16ZLw/q/VMF4Klw=
Message-ID: <aecf5e530812290311l62e0c77bk931f0c86a9fb64e6@mail.gmail.com>
Date: Mon, 29 Dec 2008 16:41:09 +0530
From: "sasa sasa" <sasak.1983@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: TTY problem on linux-2.6.28-rc7
In-Reply-To: <aecf5e530812212011n23627e94r52453aca2c9b6089@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <aecf5e530812212011n23627e94r52453aca2c9b6089@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Further debugging this issue I found that it is not an issue with tty.
But there is error in opening shared library libc.so.6 which is used
to open console.

Regards
Sasa

On Mon, Dec 22, 2008 at 9:41 AM, sasa sasa <sasak.1983@gmail.com> wrote:
> Hi All,
>
> I have recently moved to linux-2.6.28-rc7 but I am facing problem in
> getting console on arm platform when booting through initrd.
> On linux-2.6.27 system is working fine.
> The problem is that it got hang after the init process started and
> when control goes
> to user space. The request for tty_open and tty_close keeps on coming.
> Because of that the print stops coming on uart after init process.
>
> Does anybody had any idea regarding this?
>
> Regards
> Sandeep
>
