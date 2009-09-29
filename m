Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbZI2RN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbZI2RN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbZI2RN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:13:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbZI2RN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:13:26 -0400
From: Andreas Schwab <schwab@redhat.com>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v2 2/2] m68k: Cleanup linker scripts using new linker  script macros.
References: <1253119466-19488-1-git-send-email-tabbott@ksplice.com>
	<1253119466-19488-3-git-send-email-tabbott@ksplice.com>
	<10f740e80909270258o6bde0f3dk720bd5b5c091ed2f@mail.gmail.com>
	<m2ocowwngg.fsf@igel.home>
	<alpine.DEB.1.10.0909271351110.14151@dr-wily.mit.edu>
X-Yow: I guess it was all a DREAM..  or an episode of HAWAII FIVE-O...
Date: Tue, 29 Sep 2009 19:12:56 +0200
In-Reply-To: <alpine.DEB.1.10.0909271351110.14151@dr-wily.mit.edu> (Tim
	Abbott's message of "Sun, 27 Sep 2009 13:57:55 -0400 (EDT)")
Message-ID: <m3zl8dbron.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Abbott <tabbott@ksplice.com> writes:

> Below is a new version of the second patch that attempts to address this 
> by putting the ALIGN inside a section, so that _end is at the end of the 
> load segment (I also did a bit more cleanup):
>
>   .init_end : {
> 	/* This ALIGN be in a section so that _end is at the end of the
> 	   load segment. */
> 	. = ALIGN(PAGE_SIZE);
> 	__init_end = .;
>   }
>   
>   _end = .;

This works fine.

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
