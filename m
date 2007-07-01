Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbXGAQXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbXGAQXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 12:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbXGAQXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 12:23:47 -0400
Received: from gw.goop.org ([64.81.55.164]:45072 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbXGAQXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 12:23:46 -0400
Message-ID: <4687D50F.1050007@goop.org>
Date: Sun, 01 Jul 2007 09:23:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Roman Zippel <zippel@linux-m68k.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Arch <linux-arch@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] cross-architecture ELF clean up
References: <20070620230854.246399397@goop.org> <20070620230902.387008536@goop.org> <Pine.LNX.4.64.0706251531110.4386@scrub.home> <468168FD.1080200@goop.org> <Pine.LNX.4.64.0706280027100.4890@scrub.home> <4683D78E.6080309@goop.org> <Pine.LNX.4.64.0706282319350.1817@scrub.home> <46851CF3.2070608@goop.org> <20070629181205.GA16724@uranus.ravnborg.org>
In-Reply-To: <20070629181205.GA16724@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> Grouping related things together is always a good approach. But the right
> factor should be used for the grouping. For the ELF file is would from a usage
> perspective be natural to have constants close to the definition that
> they are used to describe. Having constants grouped with other constants just
> _because_ they are constants does not cut here.

Many ELF constants are used without direct reference to their 
corresponding structures.  My linux/elf-const.h header is just a 
generalization of the existing linux/elf-em.h header, which just 
contained the ELF EM_* constants.  Given that there seems to be a 
preexisting need for the EM_* constants in a separate header, and having 
a separate elf-*.h for each group of constants is a bad idea, it seemed 
to me that elf-const.h was the appropriate direction to take.

    J
