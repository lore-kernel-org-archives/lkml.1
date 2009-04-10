Return-Path: <linux-kernel-owner+w=401wt.eu-S1761142AbZDJF5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761142AbZDJF5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 01:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbZDJF5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 01:57:35 -0400
Received: from thunk.org ([69.25.196.29]:47794 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757312AbZDJF5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 01:57:34 -0400
Date: Fri, 10 Apr 2009 01:57:25 -0400
From: Theodore Tso <tytso@mit.edu>
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-kernel@vger.kernel.org, Corrado Zoccolo <czoccolo@gmail.com>,
       =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>,
       Jan Knutar <jk-lkml@sci.fi>
Subject: Re: SSD and IO schedulers
Message-ID: <20090410055725.GC10557@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org,
	Corrado Zoccolo <czoccolo@gmail.com>,
	=?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>,
	Jan Knutar <jk-lkml@sci.fi>
References: <4dcf7d360901301355l7ed26a5aob7ef6d79d9607b6b@mail.gmail.com> <20090204004003.26068f72@werewolf.home> <200902071858.40146.jk-lkml@sci.fi> <4e5e476b0904081218i29871702qc8bacb680c51ec2c@mail.gmail.com> <20090408195610.GA5447@fancy-poultry.org> <49DE8B30.3080208@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DE8B30.3080208@tmr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 07:56:32PM -0400, Bill Davidsen wrote:
> This is good information, and if I ever configure a netbook for run 
> fsync-tester I shall avoid the DL scheduler. ;-(
>
> However... this test, and several others designed to find the ultimate  
> performance limits of disk io, don't mimic any typical use of most 
> desktops and virtually all netbooks.
>
> Is there a benchmark which would return so useful data for typical use, 
> doing some mail, some browsing, and maybe some light presentation, 
> spreadsheet, or word processing. None of those uses are likely to 
> generate this level of io, this file size, etc. The number of users is 
> one, it's not used as a server, and probably most of the tuning done (if 
> any) is aimed at battery life rather than blinding speed with a three 
> digit load average.

As long as you don't believe a netbook user will ever try to type an
e-mail using a mail reader like alpine (which is what Linus uses),
while running "yum update" in the background, sure.  But if you don't
think that is a normal use case, I'll let you argue with Linus on that
score.  In any case, the big-file-write-and-flush plus fsync-tester
was designed to roughly replicate this scenario which Linus saw on his
desktop system.

    	     			  	   	       - Ted
