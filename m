Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbYDJGwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbYDJGwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 02:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbYDJGwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 02:52:33 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:26004 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbYDJGwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 02:52:32 -0400
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Ingo Molnar <mingo@elte.hu>, Matti Aarnio <matti.aarnio@zmailer.org>,
       Zhao Forrest <forrest.zhao@gmail.com>, discuss@x86-64.org,
       linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com, ak@suse.de
Subject: Re: Does Linux have plan to support memory hole remapping?
From: Andi Kleen <andi@firstfloor.org>
References: <ac8af0be0804090054w47f48ddel387d80a0331d16e1@mail.gmail.com>
	<87iqyro3rc.fsf@basil.nowhere.org>
	<20080409083700.GU3700@mea-ext.zmailer.org>
	<20080409085440.GB32466@elte.hu> <1207787687.30698.97.camel@localhost>
Date: Thu, 10 Apr 2008 08:51:28 +0200
In-Reply-To: <1207787687.30698.97.camel@localhost> (Kasper Sandberg's message of "Thu, 10 Apr 2008 02:34:47 +0200")
Message-ID: <87abk2nqxb.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Apr 2008 06:44:45.0469 (UTC) FILETIME=[5D0A3CD0:01C89AD6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kasper Sandberg <lkml@metanurb.dk> writes:

> A somewhat related question is.. How come linux does not(as i understand
> it) support talking to the chipsets to do these things? wouldnt this
> also give other benefits, such as being able to more precisely control
> interrupts and stuff?

Linux is an portable operating system and not a hardware specific BIOS. So it
prefers to not know about some things.

-Andi
