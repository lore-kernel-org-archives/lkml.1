Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbZINVCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbZINVCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757124AbZINVCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:02:08 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:51473 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062AbZINVCH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:02:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=D35dDblt2uHlpBZWmMx7C1tPMsAtKtNWxqQj4jqkD4fEMUPXjX3fPNnKINBMTWDcsp
         02pXos+T3mv8xKeV8CGlcInxc2viFeF7O/s3BBiy3+kRJRrkENAgz0HkAAB/uKiJDmqR
         43pOpkxMu4aGU6p803qW1H8FMFyySCvr/WRqQ=
MIME-Version: 1.0
In-Reply-To: <1252961623.20020.56.camel@gandalf.stny.rr.com>
References: <20090614012457.GD5986@nowhere> <1244948719-22216-1-git-send-email-vapier@gentoo.org> 
	<1252957702.20020.53.camel@gandalf.stny.rr.com> <8bd0f97a0909141321t515648c7ue0a7d377b99f13f5@mail.gmail.com> 
	<1252961623.20020.56.camel@gandalf.stny.rr.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 14 Sep 2009 17:01:49 -0400
Message-ID: <8bd0f97a0909141401y56961a77nfb2b78b43e8b0426@mail.gmail.com>
Subject: Re: [PATCH v4] ftrace: document basic ftracer/ftracer graph needs
To: rostedt@goodmis.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 16:53, Steven Rostedt wrote:
> On Mon, 2009-09-14 at 16:21 -0400, Mike Frysinger wrote:
>> On Mon, Sep 14, 2009 at 15:48, Steven Rostedt wrote:
>> > On Sat, 2009-06-13 at 23:05 -0400, Mike Frysinger wrote:
>> >> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
>> >> index fd9a3e6..95a39fb 100644
>> >> --- a/Documentation/trace/ftrace.txt
>> >> +++ b/Documentation/trace/ftrace.txt
>> >> @@ -27,6 +27,12 @@ disabled, and more (ftrace allows for tracer plugins, which
>> >>  means that the list of tracers can always grow).
>> >>
>> >>
>> >> +Implementation Details
>> >> +----------------------
>> >> +
>> >> +See ftrace-implementation.txt for details for arch porters and such.
>> >
>> > Might want to specify that this is for the function tracer.
>>
>> well, all of ftrace.txt says "function tracer", so if/when someone
>> cleans that up, this will get fixed in the process.
>
> Well things do need to be clean up, the original code had the function
> tracer called ftrace, which it no longer does. Why add more incorrect
> documentation just to match the previous incorrect documentation?

if the filename is updated, do i really need to duplicate it ?

See function-tracer-design.txt for details for arch porters and such.

if people add other design/porting info, this can be a simple list and
the filename itself can imply the details contained within ...
-mike
