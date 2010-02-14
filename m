Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab0BNJuf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 04:50:35 -0500
Received: from 1wt.eu ([62.212.114.60]:56395 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019Ab0BNJud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 04:50:33 -0500
Date: Sun, 14 Feb 2010 10:49:40 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jean Delvare <khali@linux-fr.org>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>, mirrors@kernel.org,
       lasse.collin@tukaani.org, linux-kernel <linux-kernel@vger.kernel.org>,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100214094940.GB17999@1wt.eu>
References: <4B744E13.8040004@kernel.org> <20100211205129.GA26105@elf.ucw.cz> <20100213181008.479509f5@hyperion.delvare> <4B773B31.1020802@lougher.demon.co.uk> <20100214102308.1d1d6fff@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100214102308.1d1d6fff@hyperion.delvare>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Sun, Feb 14, 2010 at 10:23:08AM +0100, Jean Delvare wrote:
> I am not claiming that gzip is dead. It is very useful and it is there
> to stay for the years to come, no doubt about that. What I'm saying is
> that it isn't the best choice for large files to be downloaded from a
> remote server.

Well, I personally like to be able to simply run "less patch-2.6.27.45.gz"
and have it transparently uncompressed and dumped on my terminal. It
doesn't do that on bz2. We could find multiple examples.

Another thing comes to mind, because I've been beaten by this in the
past. People working in enterprises where the internet access passes
via mandatory proxies coupled with anti-virus can often download many
things but not binaries that can't be analysed. At this time, I could
only download tar.gz but not .bz2. And please don't tell me I have to
go to the admin to tell him to change his proxy's configuration, you
can't do that when you work as a consultant for a 20000 persons group
where products are selected after 6-12 months of testing and managed
by different people from those who qualify them.

In my opinion, .xz is a very good option to replace .bz2 as it will
bring advantages without downsides. But .gz should stay as it has
been available from day 1, at least for all people who may have
trouble with .xz for whatever reason. If it has not been a problem
for the last 16 years, I don't see why it would suddenly become one.

Regards,
Willy

