Return-Path: <linux-kernel-owner+w=401wt.eu-S1161368AbXD2VR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161368AbXD2VR3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 17:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161383AbXD2VR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 17:17:28 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:41801 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161368AbXD2VRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 17:17:11 -0400
Date: Sun, 29 Apr 2007 23:17:10 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Lee Revell <rlrevell@joe-job.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
In-Reply-To: <75b66ecd0704281412x33352e97kc9c646ea594ef9ee@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0704292314180.20994@artax.karlin.mff.cuni.cz>
References: <1177660767.6567.41.camel@Homer.simpson.net> 
 <20070427013350.d0d7ac38.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0704282242280.16099@artax.karlin.mff.cuni.cz>
 <75b66ecd0704281412x33352e97kc9c646ea594ef9ee@mail.gmail.com>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Lee Revell wrote:

> On 4/28/07, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz> wrote:
>> I most wonder, why vim fsyncs its swapfile regularly (blocking typing
>> during that) and doesn't fsync the resulting file on :w  :-/
>
> Never seen this.  Why would fsync block typing unless vim was doing
> disk IO for every keystroke?
>
> Lee

Not for every keystroke, but after some time it calls fsync(). During 
execution of that call, keyboard is blocked. It is not normally problem 
(fsync executes very fastly), but it starts to be problem in case of 
extremely overloaded system.

Mikulas
