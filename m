Return-Path: <linux-kernel-owner+w=401wt.eu-S1751241AbZBQHnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241AbZBQHnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 02:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbZBQHnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 02:43:16 -0500
Received: from sorrow.cyrius.com ([65.19.161.204]:49411 "EHLO
	sorrow.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbZBQHnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 02:43:15 -0500
Date: Tue, 17 Feb 2009 08:42:50 +0100
From: Martin Michlmayr <tbm@cyrius.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: "elf core dump: fix get_user use" breaks mips compilation
Message-ID: <20090217074250.GE2495@deprecation.cyrius.com>
References: <20090216120136.GA9057@deprecation.cyrius.com> <20090216233216.GA19484@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216233216.GA19484@linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ralf Baechle <ralf@linux-mips.org> [2009-02-16 23:32]:
> Partially expanding get_user() the code basically does this:
> 
> 	int word;
> 
> 	if (access_ok(...))
> 		__get_user(word, header);
> 	else
> 		word = 0;
> 
> And gcc is unable to figure out that word will always be assigned to by
> both paths of the if statement.  Older gcc versions used to have that
> problem.  I can't reproduce your problem with gcc 4.3.2 and I assume
> you're using something older than that?

Yes, gcc 4.1.
-- 
Martin Michlmayr
http://www.cyrius.com/
