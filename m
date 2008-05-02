Return-Path: <linux-kernel-owner+w=401wt.eu-S935478AbYEBR3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935478AbYEBR3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 13:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761613AbYEBR3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 13:29:12 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:24429 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758135AbYEBR3L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 13:29:11 -0400
To: =?utf-8?Q?J=C3=B6rn?= Engel <joern@logfs.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org
Subject: Re: LogFS merge
From: Andi Kleen <andi@firstfloor.org>
References: <20080502133234.GA24080@logfs.org>
Date: Fri, 02 May 2008 19:29:07 +0200
In-Reply-To: <20080502133234.GA24080@logfs.org> (=?utf-8?Q?J=C3=B6rn?=
 Engel's message of "Fri, 2 May 2008 15:32:34 +0200")
Message-ID: <87k5icvcm4.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 02 May 2008 17:22:13.0488 (UTC) FILETIME=[0FB94700:01C8AC79]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel <joern@logfs.org> writes:
>
> So should it simmer in -next and -mm for another month?  Should it go
> straight into -linus?

The main criteria for it going to Linus should be if you would really
trust your data to it now. Would you put your $HOME on it? Merging file 
systems too early can quickly ruin their name and that taint is hard
to ever get rid again then (e.g. happened to JFS) 

-Andi
