Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbZL2Q3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbZL2Q3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 11:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbZL2Q3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 11:29:15 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43945 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbZL2Q3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 11:29:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xBRlFY9dXfkoLsmUMaW2xpkKlEuKXerkgTb5D3Cf0foNbTB4nT5CMbZhi+yQ/0N45Y
         6uiTrJhekUoT7YvQZ8Eq6DRBcgsaRNAbvApzlolyUFKLushur/G9txcEvH0WgAxHuNkn
         w8bCfCEOqpHcbrfrA03jTtFbOECwKFGacvUYs=
Date: Tue, 29 Dec 2009 17:29:03 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [Bug #14899] reiserfs: inconsistent lock state
Message-ID: <20091229162858.GA5258@nowhere>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.0O.fnhOLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <NJVdobuNFNK.A.0O.fnhOLB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29, 2009 at 04:09:57PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14899
> Subject		: reiserfs: inconsistent lock state
> Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
> Date		: 2009-12-11 22:06 (19 days old)
> References	: http://marc.info/?l=linux-kernel&m=126056920702515&w=4
> Handled-By	: Frederic Weisbecker <fweisbec@gmail.com>
> Patch		: http://patchwork.kernel.org/patch/67256/
> 		  http://patchwork.kernel.org/patch/67257/
> 
> 


I think this precise one is solved. The problem is that there are other
vmalloc in the same path that also need to be fixed.

I have a pending patch for that but as there are other reiserfs lockdep
reports to be solved, I'm trying to pack all fixes in a same
set so that they can be tested using a simple merge.

For now, I guess this ticket shouldn't be closed until reporters
can test the whole.

Thanks!


