Return-Path: <linux-kernel-owner+w=401wt.eu-S1755097AbXKJVS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbXKJVS7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 16:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbXKJVSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 16:18:51 -0500
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:37560
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbXKJVSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 16:18:51 -0500
Date: Sat, 10 Nov 2007 13:28:25 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Andi Kleen <andi@firstfloor.org>
cc: Crispin Cowan <crispin@crispincowan.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
In-Reply-To: <p73tzntzuak.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0711101325240.4780@asgard.lang.hm>
References: <473380AD.5070801@crispincowan.com> <p73tzntzuak.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Nov 2007, Andi Kleen wrote:

> Crispin Cowan <crispin@crispincowan.com> writes:
>
> The document should be a good base for a merge.
>
>>     * A confined process can operate on a file descriptor passed to it
>>       by an unconfined process, even if it manipulates a file not in the
>>       confined process's profile. To block this attack, confine the
>>       process that passed the file descriptor.
>
> That is the only thing that tripped me up a bit while reading the document.
> Can you expand a bit on the reasons why the fd is not rechecked in
> the context of the target process? Best do it in a new version of the
> document.

from prior discussions I understand that the problem is that it's not easy 
(or nessasarily possible) to figure out the path to the fd, so what do you 
check?

if the file has been removed there _is_ no path to the fd.

with hard links there could be many paths to the fd, the only way to find 
them would be to search the entire filesystem.

as a result App Armor has decided not to try and address this, but is 
documenting it as a limitation.

David Lang
