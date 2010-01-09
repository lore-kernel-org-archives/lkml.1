Return-Path: <linux-kernel-owner+w=401wt.eu-S1751623Ab0AIIBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab0AIIBu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 03:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545Ab0AIIBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 03:01:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64019 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab0AIIBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 03:01:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: strict copy_from_user checks issues?
Date: Sat, 9 Jan 2010 09:01:36 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com> <201001090107.43402.arnd@arndb.de> <4B47C984.1080903@zytor.com>
In-Reply-To: <4B47C984.1080903@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001090901.37208.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18tiRv1XFTKOXpJqT9VGWRPEFk1ngWUwNuL2I/
 n38+kTRxkPmzt3ye86m/OkX9uOnBNNG4vmxQZWABOBZOgJOdJJ
 mRUmknssKFjomCpb9TOAg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 January 2010, H. Peter Anvin wrote:
> >       return put_user(data, uptr);
> > 
> > The latter form requires a macro instead of a function for the user copy,
> > but we now have that anyway because of the size check.
> > 
> 
> Well... we already have the latter form?

Right, but my suggestion was to extend that do data structures in
addition to the scalars we are supporting now.

	Arnd
