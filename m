Return-Path: <linux-kernel-owner+w=401wt.eu-S1751969Ab0ABT3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab0ABT3F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 14:29:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551Ab0ABT3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 14:29:04 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39206 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab0ABT3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 14:29:02 -0500
Date: Sat, 2 Jan 2010 14:56:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Valdis.Kletnieks@vt.edu, serge@hallyn.com, serue@us.ibm.com,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: A basic question about the security_* hooks
Message-ID: <20100102135649.GB5872@ucw.cz>
References: <20091225055034.GA374@us.ibm.com> <20091226195043.GA1945@heat> <20091227031631.GA17629@hallyn.com> <200912271302.JBH64754.JtLMFQVOSOFFHO@I-love.SAKURA.ne.jp> <22669.1261911374@localhost> <200912282051.BIF64080.VOMtFOOLSHJFFQ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912282051.BIF64080.VOMtFOOLSHJFFQ@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> The restorecon may not be executed due to "mount -o noexec".
> The restorecon may be replaced by "mount --bind /bin/true /sbin/restorecon".
> The restorecon may not work as expected due to improper LD_PRELOAD environment.

How are these relevant? I don't think selinux allows random users to
run /sbin/restorecon...?

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
