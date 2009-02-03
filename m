Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbZBCPTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbZBCPTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 10:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZBCPTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 10:19:45 -0500
Received: from kov.eti.br ([207.210.245.77]:51759 "EHLO kov.eti.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbZBCPTo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 10:19:44 -0500
X-Greylist: delayed 2435 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Feb 2009 10:19:44 EST
Subject: Re: cgroup mount point
From: Gustavo Noronha <kov@debian.org>
To: debian-devel@lists.debian.org
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87ljsnzo4v.fsf@benfinney.id.au>
References: <20090202200013.GU3643@vespa.holoscopio.com>
	 <1233606371.15779.32.camel@radis.liafa.jussieu.fr>
	 <20090202205246.GA28593@glandium.org>
	 <20090202214153.GV3643@vespa.holoscopio.com>
	 <20090203102416.GA8886@redhat.com>   <87ljsnzo4v.fsf@benfinney.id.au>
Content-Type: text/plain; charset=UTF-8
Organization: Debian Project
Date: Tue, 03 Feb 2009 12:38:33 -0200
Message-Id: <1233671913.8902.53.camel@abacate.horta>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8BIT
X-Spam-Score: -3.9
X-Spam_bar: ---
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 23:44 +1100, Ben Finney wrote:
> I agree with all that Thadeu Lima says here. I would add that cgroups
> are nothing to do with device nodes, so definitely don't belong in
> ‘/dev/’ either.
> 
> Since they're a filesystem mapping “for browsing and manipulation
> from user space” of a kernel facility, I think ‘/sys/cgroups/’ is
> appropriate.

I agree with this point of view. I believe /sys/cgroups is the way to
go. Now, of course this has the drawback of shadowing something future
versions of Linux would make available at that same path, but I am
pretty sure they would be careful not to do that after distributions
have settled on a standard path.

See you,

-- 
Gustavo Noronha <kov@debian.org>
Debian Project

