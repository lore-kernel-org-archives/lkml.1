Return-Path: <linux-kernel-owner+w=401wt.eu-S1763102AbYEEWIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763102AbYEEWIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760439AbYEEWIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:08:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686AbYEEWIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:08:31 -0400
Date: Mon, 5 May 2008 18:08:28 -0400
From: Rik van Riel <riel@redhat.com>
To: "Kevin Burton" <burton@tailrank.com>
Cc: "FD Cami" <francois.cami@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: Ability to limit or disable page caching?
Message-ID: <20080505180828.27acf471@cuia.bos.redhat.com>
In-Reply-To: <30c6373b0805051400jebd4132ob23ec38bdf1ccb93@mail.gmail.com>
References: <30c6373b0805050012o505c0540i116a31bc1ab9ce9f@mail.gmail.com>
	<20080505131607.5556b1f2@olorin>
	<30c6373b0805051134m634efbbdn45167c1eae29df4a@mail.gmail.com>
	<20080505212831.22371732@olorin>
	<30c6373b0805051242o2f38f0a3v62bd43f4fa01559e@mail.gmail.com>
	<20080505164446.2ec9a543@cuia.bos.redhat.com>
	<30c6373b0805051400jebd4132ob23ec38bdf1ccb93@mail.gmail.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008 14:00:51 -0700
"Kevin Burton" <burton@tailrank.com> wrote:

> > I have no such tunable in my code (yet), because I would like the
> > kernel to do the right thing automatically.  I will post a 2.6.25 based
> > kernel RPM for Fedora 9 soon with the split LRU patch series applied.
> 
> With the same patch you linked to above?  No new code..

Same patch, rediffed against 2.6.25.

> > If you feel like testing/breaking it, I would be interested to see if
> > it does indeed do the right thing for your workload or if it needs more
> > tuning.
> 
> Well we'd be deploying it in product :).. what's the ETA into making
> it into the official kernel?

The code seems to work right. What is left now is convincing Andrew Morton
and Linus Torvalds to merge it.

Getting good test results with reasonable workloads where the vanilla
kernel does the wrong thing (eg. your workload) is probably the most
important factor for Andrew and Linus in deciding whether or not to
merge the code. 

-- 
All Rights Reversed
