Return-Path: <linux-kernel-owner+w=401wt.eu-S1758011AbZBZD72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbZBZD72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 22:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbZBZD7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 22:59:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752250AbZBZD7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 22:59:18 -0500
Date: Wed, 25 Feb 2009 19:57:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during 
 suspend-resume
In-Reply-To: <d6200be20902251950l34d5968q4b553ce8305ebd4b@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0902251956450.3111@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <20090224230935.GA15165@elte.hu>  <200902250029.16107.rjw@sisk.pl>  <d6200be20902251717r531c022bl4c25fcb902201188@mail.gmail.com>  <alpine.LFD.2.00.0902251724220.3111@localhost.localdomain> 
 <d6200be20902251813o3ff4a065nb0a54321e27c512d@mail.gmail.com>  <alpine.LFD.2.00.0902251848120.3111@localhost.localdomain>  <20090226030050.GA3361@elte.hu>  <d6200be20902251931lf563c2aw43d5266e9677e168@mail.gmail.com>  <alpine.LFD.2.00.0902251935190.3111@localhost.localdomain>
 <d6200be20902251950l34d5968q4b553ce8305ebd4b@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Feb 2009, Arve Hjønnevåg wrote:
> 
> I don't think this is a oddball case. It is very common to connect
> keys or keypads to gpios. If these keys are wakeup keys, it is not OK
> to loose interrupts during the suspend phase.

.. and how many drivers is that? Is it one or two "gpio input drivers" or 
is it a hundred?

The "common" is not so much about "how many machines", but "in how many 
drivers would you actually do this".

			Linus
