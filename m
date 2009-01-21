Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbZAUQOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbZAUQOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 11:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbZAUQOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 11:14:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52844 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbZAUQOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 11:14:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Collins <paul@burly.ondioline.org>
Subject: Re: Badness at kernel/time/timekeeping.c:98 in pmud (timekeeping_suspended)
Date: Wed, 21 Jan 2009 17:13:39 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
References: <87prihcepl.fsf@burly.wgtn.ondioline.org>
In-Reply-To: <87prihcepl.fsf@burly.wgtn.ondioline.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901211713.39630.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 January 2009, Paul Collins wrote:
> Got a couple of these on a PowerBook running 2.6.29-rc2 either during
> suspend or resume -- it's hard to tell.  (The suspend message is
> timestamped in syslog with the time I resumed, so I guess it was
> buffered along with the subsequent "Badness" messages.)

Please check if the patch from http://lkml.org/lkml/2009/1/13/144 fixes the
problem for you.

Thanks,
Rafael
