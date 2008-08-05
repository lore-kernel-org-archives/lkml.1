Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbYHEEGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbYHEEGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 00:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbYHEEF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 00:05:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53139 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbYHEEF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 00:05:56 -0400
Message-ID: <4897CDA1.9060303@zytor.com>
Date: Mon, 04 Aug 2008 20:48:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Mike Travis <travis@sgi.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] dyn_array and nr_irqs support v2
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>	<m1iqukwjjg.fsf@frodo.ebiederm.org>	<86802c440808011430i6cf5cb8cn519777a78dd987b0@mail.gmail.com>	<m1wsj0nyx6.fsf@frodo.ebiederm.org>	<86802c440808011809t275aa511h4a1e9d70ede21702@mail.gmail.com>	<m163qkjirc.fsf@frodo.ebiederm.org> <4896FCD0.8050006@sgi.com>	<4897BD23.8060801@zytor.com> <m1ej54nn8q.fsf@frodo.ebiederm.org>
In-Reply-To: <m1ej54nn8q.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> The interesting implication of this is that if you have the right hardware
> and are absolutely loopy you can have more interrupt sources than can
> be described in a 32bit unsigned int, and certainly more than any sane person
> would allocate in a statically sized array.
> 

Yes, I'm quite convinced that the statically sized array is a bad idea.

	-hpa
