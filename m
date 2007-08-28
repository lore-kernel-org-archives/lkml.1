Return-Path: <linux-kernel-owner+w=401wt.eu-S1758818AbXH1XvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818AbXH1XvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 19:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbXH1XvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 19:51:13 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:34635 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbXH1XvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 19:51:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JKX8A/nF56QW8AmdegM+DdSL6VjeMYbQA3yh1SxrrhiRAK+JdyEgv4qT6q6SX9XWOdf4hxxTRP/OCxSCFqSllO5knEG6VQ4UCb9pZ8sNySUQeozJTbexIKDkU3JRn0rwD/J50GY2QyNmcoJARjY8tw4wCKyR3T7Bku1BCTcFDZo=
Message-ID: <6bffcb0e0708281651g29729d6au6b40c0f9af5beed2@mail.gmail.com>
Date: Wed, 29 Aug 2007 01:51:09 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Pete Monroe" <pizzlemonrizzle@gmail.com>
Subject: Re: Crash report 2.6.22.5
Cc: linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
       netfilter-devel@lists.netfilter.org
In-Reply-To: <24c800fb0708281140r2c46e364i77e041b6c746b60d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <24c800fb0708281140r2c46e364i77e041b6c746b60d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pete,

On 28/08/07, Pete Monroe <pizzlemonrizzle@gmail.com> wrote:
> Hi,
>
> Sorry there's not more to go on here.
>
> A 32-bit firewall running the kernel LVS virtual server to fan out to
> a dozen webservers ran fine for a year using  2.6.17.13, but won't
> last more than four hours or so with 2.6.22.5.  Another server,
> different hardware and vendor but same purpose, also crashed with
> 2.6.22.5 after a few hours.  It had previously run 2.6.20.11.  Nothing
> on the screen, nothing in the logs.
>
> I'm attaching zipped dmesg (both kernel versions),

Could you capture the bug with serial/netconsole etc.?

"Collecting kernel messages"
http://www.stardust.webpages.pl/files/handbook/handbook-en-0.3-rc1.pdf
for more info.

> .config and lspci
> -v output for one of the machines, a Dell Intel dual-Xeon box.  The
> other machine is a dual Athlon box.  Both use SCSI drives (the
> attached Dell uses MPT Fusion, the other one Adaptec.)  Intel ethernet
> on both.
>
> I did enable the Slub allocator in 2.6.22.5, figuring that if it is
> going to be the default in 2.6.23 that it's probably solid in .22.5.
>
> PLMK if any more info would be useful.
>
> Thanks,
> Pete
>
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
