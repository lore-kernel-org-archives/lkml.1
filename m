Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbZLDQAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbZLDQAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 11:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756897AbZLDQAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 11:00:43 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:53671 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818AbZLDQAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 11:00:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: x86: Is 'volatile' necessary for readb/writeb and friends?
Date: Fri, 4 Dec 2009 17:00:39 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>, x86@kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20091204092119.GA9707@laptop> <8B1FEF0C-5D71-4D64-ADC3-1EE60F50779F@kernel.crashing.org>
In-Reply-To: <8B1FEF0C-5D71-4D64-ADC3-1EE60F50779F@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912041700.39564.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19F/w5KYdSnt3gurcR5ITV0uJPyx1/OvVrqFer
 u7yY1lDB8C/vyosXrMxKIqhwjujfWkrjlfhTItxb+E4Ri/NyHM
 9pf+Xr6jSBM1dEmVnDaxA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 December 2009, Segher Boessenkool wrote:
> If you want to get all language-lawyery, if the object pointed to by
> "addr" is volatile, the volatile here is needed: accessing volatile
> objects via a not volatile-qualified lvalue is undefined.  But since
> this is GCC-specific code anyway, do you care?  :-)

I think the real reason for having it is to avoid a warning when
device drivers pass volatile objects. Not sure if that's a good
thing or if we should better actually warn about it.

	Arnd <><
