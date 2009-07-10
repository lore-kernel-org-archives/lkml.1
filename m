Return-Path: <linux-kernel-owner+w=401wt.eu-S1754443AbZGKUuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbZGKUuB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 16:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZGKUty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 16:49:54 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46032 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbZGKUtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 16:49:53 -0400
Date: Fri, 10 Jul 2009 18:17:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Geoffrey Thomas <geofft@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Return ENOEXEC, not ENOENT, if a binary's or script's
	interpreter doesn't exist.
Message-ID: <20090710161758.GC1396@ucw.cz>
References: <1247125700-12630-1-git-send-email-geofft@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247125700-12630-1-git-send-email-geofft@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-07-09 03:48:20, Geoffrey Thomas wrote:
> If you try to execute a binary compiled for ld-linux.so.1 (libc5) on a machine
> with only ld-linux.so.2 (libc6), your shell will claim "mybinary: No such file
> or directory", even though the binary exists. The ENOENT actually applies to
> the ELF intepreter, not to the file itself. The same happens if you have a
> nonexistent interpreter in a shell script's shebang line.
> 
> Give a more helpful and more expected error, "cannot execute binary file", in
> these cases.

NAK. Current behaviour is useful -- and it is really file thats
missing.

Please improve manpage instead.

(chmod 000 /lib also produces 'interesting' error messages. Better
document those, too).						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
