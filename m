Return-Path: <linux-kernel-owner+w=401wt.eu-S1762223AbYEHKUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762223AbYEHKUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 06:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757634AbYEHKUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 06:20:40 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:39414 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226AbYEHKUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 06:20:38 -0400
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Adrian Bunk <bunk@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] x86: introduce a new Linux defined feature flag for PAT support
From: Andi Kleen <andi@firstfloor.org>
References: <48210A71.1060409@keyaccess.nl>
	<86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com>
	<20080507124650.GD29935@cs181133002.pp.htv.fi>
	<alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de>
	<48221AE3.6020602@keyaccess.nl> <482233F0.7040000@zytor.com>
	<48224318.8020209@keyaccess.nl> <48224361.5080102@zytor.com>
	<48224507.8010102@keyaccess.nl>
	<alpine.LFD.1.10.0805071716060.3024@woody.linux-foundation.org>
	<48224930.9030901@keyaccess.nl> <48225DEC.2030502@keyaccess.nl>
Date: Thu, 08 May 2008 12:19:35 +0200
In-Reply-To: <48225DEC.2030502@keyaccess.nl> (Rene Herman's message of "Thu, 08 May 2008 03:57:00 +0200")
Message-ID: <878wylayiw.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 May 2008 10:12:38.0563 (UTC) FILETIME=[0B265730:01C8B0F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman <rene.herman@keyaccess.nl> writes:
>
> Use a new Linux defined X86_FEATURE_PAT_GOOD feature flag to

Better would be PAT_TESTED or PAT_RANDOMLY_APPROVED.
Most of these CPUs without PAT_GOOD have actually perfectly good PAT, as 
Windows proves every day.

The main flaw in all of this of course is that there is no procedure to test
CPUs which do not have the flag set yet.

-Andi

