Return-Path: <linux-kernel-owner+w=401wt.eu-S940350AbXHIOcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940350AbXHIOcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935348AbXHIOb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:31:57 -0400
Received: from mail.suse.de ([195.135.220.2]:35344 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935298AbXHIOb4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:31:56 -0400
To: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
References: <20070809113122.3aa508e4@oldman.hamilton.local>
	<200708091508.20626.hjk@linutronix.de>
From: Andi Kleen <andi@firstfloor.org>
Date: 09 Aug 2007 17:26:13 +0200
In-Reply-To: <200708091508.20626.hjk@linutronix.de>
Message-ID: <p73hcn8g25m.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hans-Jürgen Koch <hjk@linutronix.de> writes:

> Am Donnerstag 09 August 2007 12:31 schrieb Stephen Hemminger:
> > Since the network device documentation needs a rewrite, I was thinking
> > of using basic html format instead of just plain text. 
> 
> Why don't you simply use DocBook? Then the user has the choice to convert
> to HTML, PDF, LaTex or whatever.

In my experience it tends to be challenging to actually find all the packages
needed for that. And then it's incredibly slow -- seems to be much slower
than gcc which is somewhat of an archivement. And at least for LinuxDoc TeX usually 
can't even compile the result.

I would say the track record of existing DocBook deployment is not good enough
to justify further use. Plain html can be converted into all these
formats easily too and overall it makes a much nicer user experience.

Also I would expect much more people will know how to write html versus
DocBook.

-Andi
