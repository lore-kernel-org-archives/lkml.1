Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbZJ0Ob7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbZJ0Ob7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 10:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbZJ0Ob7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 10:31:59 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:52487 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbZJ0Ob6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 10:31:58 -0400
MIME-Version: 1.0
In-Reply-To: <200910270924.41037.rjw@sisk.pl>
References: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera>
	 <vX3ILojF2dJ.A.H8F.Yef5KB@chimera>
	 <51f3faa70910261648h242a9a2dp42cdf554a9eb1342@mail.gmail.com>
	 <200910270924.41037.rjw@sisk.pl>
Date: Tue, 27 Oct 2009 10:32:01 -0400
Message-ID: <7e0fb38c0910270732p3a7098d3jc6334e417320295d@mail.gmail.com>
Subject: Re: [Bug #14474] restorecond going crazy on 2.6.31.4 - inotify 
	regression?
From: Eric Paris <eparis@parisplace.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Robert Hancock <hancockrwd@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 4:24 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday 27 October 2009, Robert Hancock wrote:
>> On Mon, Oct 26, 2009 at 1:32 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > This message has been generated automatically as a part of a report
>> > of regressions introduced between 2.6.30 and 2.6.31.
>> >
>> > The following bug entry is on the current list of known regressions
>> > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
>> > be listed and let me know (either way).
>> >
>> >
>> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14474
>> > Subject         : restorecond going crazy on 2.6.31.4 - inotify regression?
>> > Submitter       : Robert Hancock <hancockrwd@gmail.com>
>> > Date            : 2009-10-16 0:03 (11 days old)
>> > References      : http://marc.info/?l=linux-kernel&m=125565159520489&w=4
>>
>> This is definitely reproducible on 2.6.31.4 on CentOS 5.4, I'll likely
>> try 2.6.31.5 shortly, but it doesn't seem like any of the 2.6.31.5
>> patches touch inotify..

It's a restorecond bug.  restorecon acted as if watch descriptors
could never be reused.  They weren't on old kernels and it's possible
they are reused now.  Restorecon was fixed.

http://marc.info/?l=selinux&m=125380417916233&w=2

a change in the kernel caused a buggy userspace program to break.  I
know how to put the kernel back the way it was, but I don't know if we
call this a regression, you guys tell me.

-Eric
