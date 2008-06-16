Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbYFPPdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbYFPPdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 11:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYFPPdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 11:33:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:32034 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbYFPPdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 11:33:08 -0400
Date: Mon, 16 Jun 2008 08:32:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 10872] x86_64 boot hang when CONFIG_NUMA=n
Message-Id: <20080616083225.dbfe91b8.randy.dunlap@oracle.com>
In-Reply-To: <86802c440806152115r3bbc8a48pb6912e5dd7a6e5a1@mail.gmail.com>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
	<Jn7irxIunJK.A.8UD.1IDVIB@albercik>
	<20080615093543.1b18b9eb.randy.dunlap@oracle.com>
	<86802c440806151218h7b8b6c80q4ce0f6505244e588@mail.gmail.com>
	<20080615181101.bcbab2ef.randy.dunlap@oracle.com>
	<86802c440806152115r3bbc8a48pb6912e5dd7a6e5a1@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jun 2008 21:15:17 -0700 Yinghai Lu wrote:

> On Sun, Jun 15, 2008 at 6:11 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > On Sun, 15 Jun 2008 12:18:42 -0700 Yinghai Lu wrote:
> >
> >> On Sun, Jun 15, 2008 at 9:35 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >> > On Sat, 14 Jun 2008 22:12:04 +0200 (CEST) Rafael J. Wysocki wrote:
> >> >
> >> >> This message has been generated automatically as a part of a report
> >> >> of recent regressions.
> >> >>
> >> >> The following bug entry is on the current list of known regressions
> >> >> from 2.6.25.  Please verify if it still should be listed.
> >> >>
> >> >>
> >> >> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=10872
> >> >> Subject               : x86_64 boot hang when CONFIG_NUMA=n
> >> >> Submitter     : Randy Dunlap <randy.dunlap@oracle.com>
> >> >> Date          : 2008-06-05 21:50 (10 days old)
> >> >> References    : http://marc.info/?l=linux-kernel&m=121270308607116&w=4
> >> >>                 http://lkml.org/lkml/2008/6/11/355
> >> >> Handled-By    : Yinghai Lu <yhlu.kernel@gmail.com>
> >> >
> >> > Yes, still happens for me on 2.6.26-rc6-git2.
> >> >
> >>
> >> please send out whole boot log with numa on and numa off
> >> and boot with debug
> >>
> >> please apply attached debug patch too.
> >
> > OK, did all of that.
> > I should probably note that in both cases, the kernel is loaded/booted by using kexec.
> > Both boot logs are captured generated via netconsole.
> >
> > The failing boot log is netcon-4409.log.  The working boot log (CONFIG_NUMA=y) is
> > netcon-4410.log.  Enabling CONFIG_NUMA makes the following changes:
> 
> how about the numa=off on the kernel with CONFIG_NUMA=y?

Hi,
That hangs the same way as the previous.

BTW, that kernel boot option needs to be documented in
Documentation/kernel-parameters.txt ...

---
~Randy
'"Daemon' is an old piece of jargon from the UNIX operating system,
where it referred to a piece of low-level utility software, a
fundamental part of the operating system."
