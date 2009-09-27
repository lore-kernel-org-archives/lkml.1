Return-Path: <linux-kernel-owner+w=401wt.eu-S1752281AbZI0TwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbZI0TwD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 15:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbZI0TwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 15:52:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:50879 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbZI0TwC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 15:52:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hpBp1iROxc2n7jPfbg3NQtbi0IoKG4PuPNKHbGuJRUQ8LHB4zQbPawMXENtgdfMUVr
         elZhCsAopH86eMbX4FCHd7ClLUJfIN9Jt5+qtaoVSfDhiQztNLCWorzrXtWVVtRvnxNc
         a6AjOuNQe/1iTcFYHLyBT4DrbTbI0DocJeM7s=
MIME-Version: 1.0
In-Reply-To: <f6ca9fed0909271250h61e2ce94n31c9f23e835f802c@mail.gmail.com>
References: <f6ca9fed0909271247k7fad64b1g1c4c65544196d7ac@mail.gmail.com>
	 <f6ca9fed0909271250h61e2ce94n31c9f23e835f802c@mail.gmail.com>
Date: Sun, 27 Sep 2009 21:52:05 +0200
Message-ID: <f6ca9fed0909271252m395a6det40fede669495c994@mail.gmail.com>
Subject: Re: sched regression introduced by NO_NEW_FAIR_SLEEPERS
From: drago01 <drago01@gmail.com>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: mingo@redhat.com, Chuck Ebbert <cebbert@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 9:50 PM, drago01 <drago01@gmail.com> wrote:
> On Sun, Sep 27, 2009 at 9:47 PM, drago01 <drago01@gmail.com> wrote:
>> Hi,
>>
>> Chuck has backported some scheduler patches from 2.6.32 to the fedora kernel.
>>
>> I did the following test to test the new scheduler (cpu is a core i7
>> 920 4 cores + HT).
>>
>> run 8 "md5sum /dev/urandom" task and try to use the desktop (compiz).
>>
>> The result was that moving windows or rotating the cube is very slow.
>> (same happens with pure metacity but is is worse in compiz).
>>
>> Mounting debugfs and doing "echo NEW_FAIR_SLEEPERS > sched_features"
>> results into a useable desktop while the 8 md5sum tasks are running
>> (ie. the system behaves as if they where not running at all from an
>> interactivity pov).
>>
>>
>> P.S: please CC me when replying.
>>
>
> With "NEW_FAIR_SLEEPERS" I can even run 100(!)  "md5sum" task without
> any effect on interactivity. (still have not found a number of tasks
> needed to make the system unresponsive as with 8 with
> "NO_NEW_FAIR_SLEEPERS".

Well ok I can expirence some delays when switching workspaces with 100
tasks but it is still better than 8 with "NO_NEW_FAIR_SLEEPERS"
