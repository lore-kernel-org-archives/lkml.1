Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbZFCQcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbZFCQcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 12:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbZFCQcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 12:32:07 -0400
Received: from mail-px0-f182.google.com ([209.85.216.182]:36565 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbZFCQcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 12:32:06 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0906030925480.4880@localhost.localdomain>
References: <20090530192829.GK6535@oblivion.subreption.com>
	 <20090531022158.GA9033@oblivion.subreption.com>
	 <alpine.DEB.1.10.0906021130410.23962@gentwo.org>
	 <20090602203405.GC6701@oblivion.subreption.com>
	 <alpine.DEB.1.10.0906031047390.15621@gentwo.org>
	 <alpine.LFD.2.01.0906030800490.4880@localhost.localdomain>
	 <alpine.DEB.1.10.0906031121030.15621@gentwo.org>
	 <alpine.LFD.2.01.0906030827580.4880@localhost.localdomain>
	 <7e0fb38c0906030922u3af8c2abi8a2cfdcd66151a5a@mail.gmail.com>
	 <alpine.LFD.2.01.0906030925480.4880@localhost.localdomain>
Date: Wed, 3 Jun 2009 12:32:07 -0400
Message-ID: <7e0fb38c0906030932o28d5c963y8059672e5c2c7ecf@mail.gmail.com>
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change 
	ZERO_SIZE_PTR to point at unmapped space)
From: Eric Paris <eparis@parisplace.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       "Larry H." <research@subreption.com>, linux-mm@kvack.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, pageexec@freemail.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 3, 2009 at 12:28 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Wed, 3 Jun 2009, Eric Paris wrote:
>>
>> As I recall the only need for CONFIG_SECURITY is for the ability to
>> override the check.
>
> No, if you have SECURITY disabled entirely, the check goes away.

I meant 'need' as in the reason I wrapped it in CONFIG_SECURITY, not
that you were wrong when you said it disapeared.

>> I think I could probably pretty cleanly change it to use
>> CAP_SYS_RAWIO/SELinux permissions if CONFIG_SECURITY and just allow it
>> for uid=0 in the non-security case?
>
> We probably should, since the "capability" security version should
> generally essentially emulate the regular non-SECURITY case for root.

Will poke/patch this afternoon.

-Eric
