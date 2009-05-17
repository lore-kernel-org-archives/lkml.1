Return-Path: <linux-kernel-owner+w=401wt.eu-S1751871AbZEQMBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbZEQMBj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 08:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbZEQMB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 08:01:29 -0400
Received: from mail-pz0-f115.google.com ([209.85.222.115]:62890 "EHLO
	mail-pz0-f115.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbZEQMB2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 08:01:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oreUd7ltGLayYXLLEvlmxkbfMMB2jx2tl7C9KPuG1hjLA/KNLOdIQLeOdYy/gvbr34
         JLrV5l0jfwyWU9KYSPum6FsXc5LffQ0SLLrTCbL5wg8j4SqfxgGKi1+3tw5Rx9NuWcZ5
         pqAw4z4ZeD4XIFd0kYU4hsTTb8AfxPhiY0q1Q=
MIME-Version: 1.0
In-Reply-To: <20090517093004.GA2635@localhost>
References: <2c0942db0905151102y4f144437xa02632effccda72c@mail.gmail.com>
	 <2c0942db0905160903i5517d3d6l50fc7457a2629694@mail.gmail.com>
	 <4A0EFA08.4060106@redhat.com> <20090517011906.GA6375@localhost>
	 <93655eb70905161827x34a432ebn4910ee86d9bae30@mail.gmail.com>
	 <20090517020829.GB6809@localhost>
	 <93655eb70905162130k13ebd627o5eba2582508a1c07@mail.gmail.com>
	 <20090517045800.GA32723@localhost>
	 <93655eb70905162318oeccafa9p76b5594f9625aefc@mail.gmail.com>
	 <20090517093004.GA2635@localhost>
Date: Sun, 17 May 2009 17:31:29 +0530
Message-ID: <93655eb70905170501q3caf04acj761ff61b539b7d40@mail.gmail.com>
Subject: Re: unresponsiveness on linux desktop during file copy
From: Satish Eerpini <eerpini@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Rik van Riel <riel@redhat.com>, Ray Lee <ray-lk@madrabbit.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm, how do you define/feel the unresponsiveness?  Is it related to
> the currently *running* applications, or opening a *new* application?

the unresponsiveness is for both the currently running applications
and for opening new applications, here are some pointers :

--> during normal operation, swtiching between windows( alt+tab) is
simultaneous, while during a file copy it takes around 1 second, which
I think is quite a lag.
--> Opening a simple application like gnome-terminal takes a second or
more for sure when there is a file copy going on.
-->Also a particular window after gaining focus takes a second or so,
to resume what it was doing, .. so if I am copying a file in a session
of gnome-terminal and open another session of gnome-terminal and type
in "clear" it takes around 2 seconds before the screen is cleared on
the second session,
this is the case with almost every application and worser with big
ones like firefox and office. This was the kind of unresponsiveness I
was talking about.

Cheers
Satish
-- 
http://satish.playdrupal.com
