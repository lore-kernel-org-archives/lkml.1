Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbYDIIC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbYDIIC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 04:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbYDIICN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 04:02:13 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:34490 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbYDIICN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 04:02:13 -0400
To: "Zhao Forrest" <forrest.zhao@gmail.com>
Cc: discuss@x86-64.org, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       mingo@elte.hu, ak@suse.de
Subject: Re: Does Linux have plan to support memory hole remapping?
From: Andi Kleen <andi@firstfloor.org>
References: <ac8af0be0804090054w47f48ddel387d80a0331d16e1@mail.gmail.com>
Date: Wed, 09 Apr 2008 10:01:59 +0200
In-Reply-To: <ac8af0be0804090054w47f48ddel387d80a0331d16e1@mail.gmail.com> (Zhao Forrest's message of "Wed, 9 Apr 2008 15:54:01 +0800")
Message-ID: <87iqyro3rc.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Apr 2008 07:55:15.0699 (UTC) FILETIME=[0C0A5C30:01C89A17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Zhao Forrest" <forrest.zhao@gmail.com> writes:
>
> As we can see from above information that the physical memory in system
> is 32768MB(32GB). However OS is only using about
> (32768-512)MB(MemTotal:     33010240 kB). Does this mean that this
> linux kernel can't use the physical memory remapped
> from (4G-512M, 4G) to (32G, 32G+512M)?

The linux kernel can only use the memory passed to it by the BIOS.
Sometimes they need special BIOS setup options to enable remapping. If
there are no such options and you can't upgrade it you're out of luck

I would suggest you contact your system vendor.

-Andi
