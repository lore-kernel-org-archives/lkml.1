Return-Path: <linux-kernel-owner+w=401wt.eu-S1758882AbYAHObW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882AbYAHObW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 09:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbYAHObN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 09:31:13 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:4881 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349AbYAHObM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 09:31:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=D3mnPPE2NCP1nN57Ji/VFQ5AeNogDNWq63i6/KV7NBia4bYbmU+NvjDpOovr0JJgnmg0cyXjGcO+pOOAxOzewV+rZt433KVsmaj+pWlram8m9iKiOwMhu+dlkZF6pG/WVimtsoFvBkJO0U7WBdqZEejCtGvHPpaR5Gi3ACF3nAk=
Message-ID: <3ae72650801080631p2b2c50a6q3d59badf06b62684@mail.gmail.com>
Date: Tue, 8 Jan 2008 15:31:11 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 12/11] sched: rt-group: uid-group interface
Cc: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>, vatsa@linux.vnet.ibm.com,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>, dmitry.adamushko@gmail.com,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <1199790150.7143.57.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080106161128.152634000@chello.nl>
	 <1199703080.7143.24.camel@twins>
	 <20080107122330.GB25945@linux.vnet.ibm.com>
	 <1199725063.31975.53.camel@lappy>
	 <20080108105733.GA2569@linux.vnet.ibm.com>
	 <1199790150.7143.57.camel@twins>
X-Google-Sender-Auth: 318b3ebf53be69cd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 8, 2008 12:02 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> On Tue, 2008-01-08 at 16:27 +0530, Dhaval Giani wrote:
> > On Mon, Jan 07, 2008 at 05:57:42PM +0100, Peter Zijlstra wrote:
> > >
> > > Subject: sched: rt-group: add uid-group interface
> > >
> > > Extend the /sys/kernel/uids/<uid>/ interface to allow setting
> > > the group's rt_period and rt_runtime.
> > >
> >
> > Hi Peter,
> >
> > Cool stuff! I will try out these patches and try to give you some
> > feedback.
>
> Thanks, much appreciated!
>
> > One request though, could you please add some documentation to
> > Documentation/ABI/testing/sysfs-kernel-uids?
>
> I already have documentation on the todo list, I'll add this file to
> that list :-)

Care to rebase the patch against -mm, we fixed the mixed-up usage
of ksets and kobjects, and this can not apply anymore:
  http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob;f=driver/struct-user_info-sysfs.patch;hb=HEAD

There is also an attribute group now which makes it much easier to add
new files.

Thanks,
Kay
