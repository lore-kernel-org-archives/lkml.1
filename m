Return-Path: <linux-kernel-owner+w=401wt.eu-S1752132AbZI0UGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbZI0UGS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 16:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbZI0UGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 16:06:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:50615 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbZI0UGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 16:06:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=v65u6U3LpaEUPPV+CChtiTmqRYDeUbbhxJDwjVJVFFrSOA5rfs46UWL/rO/Q21CYu3
         VO8Z0Em2QtUBUQuGBLvPds7h5Mz2Dku4c0oFBDqYwRvN1cT6hZ3VCuqKV/+X1GvOpfCJ
         GndSySZV/E4Z+sQ78ihIEUGjBwyHtxurGZ24I=
MIME-Version: 1.0
In-Reply-To: <f6ca9fed0909271247k7fad64b1g1c4c65544196d7ac@mail.gmail.com>
References: <f6ca9fed0909271247k7fad64b1g1c4c65544196d7ac@mail.gmail.com>
Date: Sun, 27 Sep 2009 22:06:21 +0200
Message-ID: <f6ca9fed0909271306j2f870407he2eff773a613a50f@mail.gmail.com>
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

OK, tried on a "vanilla 2.6.30.8 scheduler" I can reproduce this by
toggling  NEW_FAIR_SLEEPERS on/off. (So it was not a side effect of
other scheduler patches)
