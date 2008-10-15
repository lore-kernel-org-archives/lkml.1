Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbYJOLuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbYJOLuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 07:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYJOLtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 07:49:52 -0400
Received: from outbound-mail-139.bluehost.com ([67.222.39.29]:47668 "HELO
	outbound-mail-139.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751080AbYJOLtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 07:49:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=hZ+7/+xqC69AIBujq0VjfQz02RA2cKpTltH9YsR39/H0w9QvGDVAbxhHO38+M0xHBYHcS9gRu2N+dAkPjQFeEVHNPdqQBQS5OKhlS7wMadO7yyd1q2KHvVMYTfJXpCVm;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jason Wessel <jason.wessel@windriver.com>
Subject: Re: kgdb for 2.6.26
Date: Wed, 15 Oct 2008 04:49:47 -0700
User-Agent: KMail/1.9.10
Cc: anils_r@yahoo.com, linux-kernel@vger.kernel.org
References: <444546.96900.qm@web32406.mail.mud.yahoo.com> <48F54923.1080904@windriver.com>
In-Reply-To: <48F54923.1080904@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810150449.47693.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 90.152.48.188 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 14, 2008 6:36 pm Jason Wessel wrote:
> Anil kumar wrote:
> > Hi,
> >
> > I found that kgdb is now able in kernel 2.6.26. Is there any other patch
> > I need to have kgdb up and running for this kernel like 8250.patch,
> > i386.patch along with this. If so, can you please point me to the
> > location to pick it for this kernel.
> >
> > with regards,
> >   Anil
>
> If you are looking for other I/O drivers such as the kgdb_8250 module,
> you can find the full kgdb patch set (which is not all in the mainline at:
>
> http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=shor
>tlog;h=kgdb_2.6.26
>
> All that is merged in the 2.6.26 kernel is kgdb core, x86 arch specific
> kgdb, and the kgdboc (kgdb over serial console) I/O module.

Jason, any word yet on a netpoll (or whatever) based kgdb interface?  Using 
gdb over the network is much easier to do against several machines than 
setting up a bunch of serial cables...

Jesse
