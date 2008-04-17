Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbYDQANv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbYDQANv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 20:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbYDQANn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 20:13:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59346 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbYDQANm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 20:13:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: Re: APM lockups since 2.6.25
Date: Thu, 17 Apr 2008 02:14:25 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0803191608500.25941@artax.karlin.mff.cuni.cz> <Pine.LNX.4.64.0804162239560.25729@artax.karlin.mff.cuni.cz> <Pine.LNX.4.64.0804162243550.25729@artax.karlin.mff.cuni.cz>
In-Reply-To: <Pine.LNX.4.64.0804162243550.25729@artax.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804170214.26368.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 16 of April 2008, Mikulas Patocka wrote:
> > So it didn't help, I just got this (2.6.25-rc8):
> > 
> > (I have turned lockdep on few days ago, and it seems to try to release a 
> > lock that's not held ... and then reacquire that lock again and deadlock)
> 
> BTW. the first one message happened immediatelly after APM resume, the 
> second message 2 minutes later.
> 
> APMD didn't set time after resume, it's completely locked up.

Well, unfortunately, APM uses the generic code for suspending and resuming
devices, but it doesn't use the freezing of tasks, so it's not very reliable in
its present form.

Thanks,
Rafael
