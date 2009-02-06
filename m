Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbZBFJQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbZBFJQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 04:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZBFJQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 04:16:24 -0500
Received: from mx0.towertech.it ([213.215.222.73]:44015 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751368AbZBFJQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 04:16:21 -0500
Date: Fri, 6 Feb 2009 10:16:18 +0100
From: Alessandro Zummo <azummo-lists@towertech.it>
To: David Brownell <david-b@pacbell.net>
Cc: jordan@cosmicpenguin.net, linux-geode@lists.infradead.org,
       dilinger@queued.net, dsaxena@laptop.org,
       "=?ISO-8859-1?Q?Martin-=C9ric?= Racine" <q-funk@iki.fi>,
       lkml <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] AMD Geode CS5535/5536 GPIO driver
Message-ID: <20090206101618.7102e46b@i1501.lan.towertech.it>
In-Reply-To: <200902051612.20475.david-b@pacbell.net>
References: <20090205161007.4d121cbf@i1501.lan.towertech.it>
	<200902051612.20475.david-b@pacbell.net>
Organization: Tower Technologies
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009 16:12:20 -0800
David Brownell <david-b@pacbell.net> wrote:

> Unless this hardware misbehaves when both output and input
> modes are enabled (e.g. in the window between those two calls),
> I'd suggest just not clearing INPUT_ENABLE.  It's legit to
> ask for the *actual* value of an output line, e.g. for when
> it uses open drain mode.  (And didn't this hardware have an
> option for open drain GPIO signaling?)

 seems reasonable,
 I'll let the Geode people decide what to do here... 

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

