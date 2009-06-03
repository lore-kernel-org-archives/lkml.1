Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbZFCQYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbZFCQYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 12:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbZFCQYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 12:24:03 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:59148 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbZFCQYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 12:24:02 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0906030918490.4880@localhost.localdomain>
References: <20090530192829.GK6535@oblivion.subreption.com>
	 <20090531022158.GA9033@oblivion.subreption.com>
	 <alpine.DEB.1.10.0906021130410.23962@gentwo.org>
	 <20090602203405.GC6701@oblivion.subreption.com>
	 <alpine.DEB.1.10.0906031047390.15621@gentwo.org>
	 <alpine.LFD.2.01.0906030800490.4880@localhost.localdomain>
	 <alpine.DEB.1.10.0906031121030.15621@gentwo.org>
	 <alpine.LFD.2.01.0906030827580.4880@localhost.localdomain>
	 <20090603171409.5c60422c@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.01.0906030918490.4880@localhost.localdomain>
Date: Wed, 3 Jun 2009 12:24:03 -0400
Message-ID: <7e0fb38c0906030924q73ffb387h2d20df7f8c2e75ba@mail.gmail.com>
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change 
	ZERO_SIZE_PTR to point at unmapped space)
From: Eric Paris <eparis@parisplace.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Christoph Lameter <cl@linux-foundation.org>,
       "Larry H." <research@subreption.com>, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 3, 2009 at 12:19 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Wed, 3 Jun 2009, Alan Cox wrote:
>>
>> Fedora at least uses SELinux to manage it. You need some kind of security
>> policy engine running as a few apps really need to map low space (mostly
>> for vm86)
>
> Well, vm86 isn't even an issue on x86-64, so it's arguable that at least a
> few cases could very easily just make it more static and obvious.

Wine does/did also use a zero page, can't remember what they used it
for off hand but they were mad at me when I added this....

-Eric
