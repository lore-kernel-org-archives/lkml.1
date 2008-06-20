Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYFTJN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYFTJN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 05:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYFTJNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 05:13:18 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:20074 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbYFTJNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 05:13:17 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: update mptable v7
From: Andi Kleen <andi@firstfloor.org>
References: <200806011317.38622.yhlu.kernel@gmail.com>
	<alpine.LFD.1.10.0806181812580.3074@localhost.localdomain>
	<86802c440806181532g348864e1u3d067f8366046a7f@mail.gmail.com>
	<alpine.LFD.1.10.0806182031060.3074@localhost.localdomain>
	<86802c440806181749g2faf1892iea693717ea919631@mail.gmail.com>
	<m1mylim4e6.fsf@frodo.ebiederm.org>
	<alpine.LFD.1.10.0806190121210.3613@localhost.localdomain>
	<m1abhilyl0.fsf@frodo.ebiederm.org>
	<86802c440806190031q17049054md2a790224d30d29@mail.gmail.com>
	<alpine.LFD.1.10.0806191412100.3040@localhost.localdomain>
	<20080620064750.GB31182@elte.hu>
Date: Fri, 20 Jun 2008 11:12:45 +0200
In-Reply-To: <20080620064750.GB31182@elte.hu> (Ingo Molnar's message of "Fri, 20 Jun 2008 08:47:50 +0200")
Message-ID: <871w2sbhbm.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Jun 2008 09:05:30.0983 (UTC) FILETIME=[CA49A770:01C8D2B4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> Yinghai: Len has a point, could you please double-check that no 
> potentially risky code runs by default anywhere, without a specific boot 
> option? update_mptable is supposed to achieve that, but lets make sure 
> it does its job.

It's not done for the NUMAQ genericarch.

-Andi
