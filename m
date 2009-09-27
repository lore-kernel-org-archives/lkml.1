Return-Path: <linux-kernel-owner+w=401wt.eu-S1751935AbZI0TuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbZI0TuJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 15:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbZI0TuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 15:50:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:32399 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbZI0TuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 15:50:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pZYw/+uydahQ6D5/HPZAhdkK7D5+S5bt3IDfYVUA61PX1MXlMmjFg0QoOzfRz8KduH
         d5VWmR/3QvL6z6Vr5i/Hw7pvu2Q/4bTD25C3drtDbghRdYCHvNgLJ4oRohoaB8ttsIr7
         9sLWSK+Assw8fFvZCDFtF0Gk5GgzZ8+uZVBvQ=
MIME-Version: 1.0
In-Reply-To: <f6ca9fed0909271247k7fad64b1g1c4c65544196d7ac@mail.gmail.com>
References: <f6ca9fed0909271247k7fad64b1g1c4c65544196d7ac@mail.gmail.com>
Date: Sun, 27 Sep 2009 21:50:10 +0200
Message-ID: <f6ca9fed0909271250h61e2ce94n31c9f23e835f802c@mail.gmail.com>
Subject: Re: sched regression introduced by NO_NEW_FAIR_SLEEPERS
From: drago01 <drago01@gmail.com>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: mingo@redhat.com, Chuck Ebbert <cebbert@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 9:47 PM, drago01 <drago01@gmail.com> wrote:
> Hi,
>
> Chuck has backported some scheduler patches from 2.6.32 to the fedora kernel.
>
> I did the following test to test the new scheduler (cpu is a core i7
> 920 4 cores + HT).
>
> run 8 "md5sum /dev/urandom" task and try to use the desktop (compiz).
>
> The result was that moving windows or rotating the cube is very slow.
> (same happens with pure metacity but is is worse in compiz).
>
> Mounting debugfs and doing "echo NEW_FAIR_SLEEPERS > sched_features"
> results into a useable desktop while the 8 md5sum tasks are running
> (ie. the system behaves as if they where not running at all from an
> interactivity pov).
>
>
> P.S: please CC me when replying.
>

With "NEW_FAIR_SLEEPERS" I can even run 100(!)  "md5sum" task without
any effect on interactivity. (still have not found a number of tasks
needed to make the system unresponsive as with 8 with
"NO_NEW_FAIR_SLEEPERS".
