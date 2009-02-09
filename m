Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbZBINuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbZBINuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbZBINuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:50:04 -0500
Received: from mail-ausfall.charite.de ([193.175.70.131]:40080 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbZBINuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:50:01 -0500
Date: Mon, 9 Feb 2009 14:49:58 +0100
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Federico Cuello <fedux@lugmen.org.ar>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Subject: Re: sync-Regression in 2.6.28.2?
Message-ID: <20090209134958.GP27548@charite.de>
Mail-Followup-To: Nick Piggin <nickpiggin@yahoo.com.au>,
	Federico Cuello <fedux@lugmen.org.ar>,
	Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
	linux-kernel@vger.kernel.org
References: <20090127093533.GB7037@charite.de> <200902051425.19552.nickpiggin@yahoo.com.au> <498AD368.2090000@lugmen.org.ar> <200902100045.44386.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200902100045.44386.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch seems good to me. If you would care to add a changelog and
> Signed-off-by: line, then we could get it merged?
> 
> I am not too sure about this bug. I have reproduced a strange hang with
> ext4 (which does include sys_sync and write_cache_pages traces), and
> also turned up a lockdep report. Also, we haven't seen any reports of
> this problem on other filesystems. So it could be an ext4 bug.
> 
> Your traces also have lots of tasks hung waiting for page lock. It is
> possible that wakeups get lost, which is fixed by this commit in
> mainline
> 777c6c5f1f6e757ae49ecca2ed72d6b1f523c007
> 
> Which might also be your bug.
> 
> 
> Any chance you can test this patch (as well as the existing patches
> you are using to fix write_cache_pages?).

I could test 2.6.28.4

-- 
Ralf Hildebrandt                                Ralf.Hildebrandt@charite.de
Charite - Universitätsmedizin Berlin            Tel.  +49 (0)30-450 570-155
Geschäftsbereich IT | Abt. Netzwerk             Fax.  +49 (0)30-450 570-962
Hindenburgdamm 30 | 12200 Berlin
