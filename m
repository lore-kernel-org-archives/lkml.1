Return-Path: <linux-kernel-owner+w=401wt.eu-S1752871AbYJBD5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbYJBD5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 23:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYJBD5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 23:57:05 -0400
Received: from brain.cel.usyd.edu.au ([129.78.24.68]:58140 "EHLO
	brain.cel.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbYJBD5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 23:57:04 -0400
Message-Id: <5.1.1.5.2.20081002034828.021ee6b0@brain.cel.usyd.edu.au>
X-Mailer: QUALCOMM Windows Eudora Version 5.1.1
Date: Thu, 02 Oct 2008 03:56:22 +1000
To: Arjan van de Ven <arjan@infradead.org>
From: sena seneviratne <auntvini@cel.usyd.edu.au>
Subject: Re: Division of Load Average
Cc: linux-kernel@vger.kernel.org, balbir@in.ibm.com
In-Reply-To: <20081001204311.241e04e5@infradead.org>
References: <7971648.51222945125819.JavaMail.root@wombat.diezmil.com>
 <7971648.51222945125819.JavaMail.root@wombat.diezmil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan and Balbir,

Yes as discussed and agreed upon with Nagar and balbir  4 years ago this is 
how they are listed

Loadavg(1), Loadavg(5), Loadavg(15)
rootloadavg
uid_1    CPUload_1   DiskLoad_1
uid_2   CPUload_2   DiskLoad_2
uid_3   CPUload_3   DiskLoad_3

-----------------------------------------------

uid_n    CPUload_n   DiskLoad_n

Thanks
Sena Seneviratne



At 08:43 PM 10/1/2008 -0700, you wrote:
>On Thu, 2 Oct 2008 06:58:45 -0400
>auntvini@cel.usyd.edu.au wrote:
>
> > My self and my superviosr Dr David Levy have been working on
> > introduction of new kernel code to correct the inherent problem of
> > calculating load avarage by the current kernel. We have posted many
> > e-mails in this regard since 2003 and kernel has been updated under
> > the supervision of Rusty Russel.
> >
> > Also we had interactions with IBM group(balbir@in.ibm.com)  who was
> > engaged in delayed stat calculations.
> >
> > We emphasise the following facts
> > (1) seperation of Disk IO load from CPU load
> >
> > This comes as a correction to the existing kernel as the calculation
> > of the existing kernel load average is based on the arithmatic
> > addition of Disk IO and CPU loads
>
>while you can argue if including disk makes sense or not, it's 20+
>years of tradition on Linux, and more on Unix.
>
>So.. whatever you do (and I think there's some sense in splitting
>things out).. please only *add* stats, don't replace the existing ones.
>
>--
>Arjan van de Ven        Intel Open Source Technology Centre
>For development, discussion and tips for power savings,
>visit http://www.lesswatts.org

