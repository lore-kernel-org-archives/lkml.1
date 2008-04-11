Return-Path: <linux-kernel-owner+w=401wt.eu-S1760154AbYDKKjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154AbYDKKjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 06:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758703AbYDKKje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 06:39:34 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:39596 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758450AbYDKKje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 06:39:34 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Kosina <jkosina@suse.cz>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
From: Andi Kleen <andi@firstfloor.org>
References: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com>
	<Pine.LNX.4.64.0804072348050.26562@twin.jikos.cz>
	<20080411102548.GO10801@elte.hu>
Date: Fri, 11 Apr 2008 12:39:20 +0200
In-Reply-To: <20080411102548.GO10801@elte.hu> (Ingo Molnar's message of "Fri, 11 Apr 2008 12:25:48 +0200")
Message-ID: <87r6dcllpj.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Apr 2008 10:32:35.0964 (UTC) FILETIME=[5BB3FBC0:01C89BBF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Jiri Kosina <jkosina@suse.cz> wrote:
>
>> [ CCs added ]
>
> thanks Jiri, i've applied both patches of yours. (let me know if there 
> are any updated patches)

Please unapply them, as discussed in the earlier thread they are not
the correct fix. The original bug is still not found unfortunately, but it's 
most likely somewhere in the KVM suspend/resume code.

-Andi
