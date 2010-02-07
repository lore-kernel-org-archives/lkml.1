Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab0BGKt7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 05:49:59 -0500
Received: from mx2.cluster1.pyrox.eu ([78.46.200.219]:57927 "EHLO
	mx2.cluster1.pyrox.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab0BGKt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 05:49:58 -0500
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Feb 2010 05:49:57 EST
Message-ID: <4B6E9866.8070108@feurix.com>
Date: Sun, 07 Feb 2010 11:39:34 +0100
From: John Feuerstein <john@feurix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100206 Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Justin P. Mattock" <justinmattock@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.33-rc7
References: <alpine.LFD.2.00.1002061422430.3829@localhost.localdomain>	<alpine.LFD.2.00.1002061445210.3829@localhost.localdomain>	<4B6E4793.3010201@teksavvy.com> <4B6E4AF2.8080603@gmail.com>
In-Reply-To: <4B6E4AF2.8080603@gmail.com>
X-Enigmail-Version: 1.0.1
OpenPGP: id=5C7CB166
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've looked up the GNU tar history, just in case this is relevant:

[1] 1994-11-16 Version 1.11  -z --gzip
[2] 1999-02-01 Version 1.12  -y --bzip2
[3] 2000-10-24 Version 1.12+ -j --bzip2
[4] 2007-10-17 Version 1.20+    --lzma
[5] 2008-06-26 Version 1.20+ -J --lzma
[6] 2008-06-26 Version 1.20+    --lzop
[7] 2009-03-04 Version 1.21+ -J --xz

GNU Tar: http://www.gnu.org/software/tar/

[1] http://git.savannah.gnu.org/gitweb/?p=tar.git;a=commit;h=17badf1
[2] http://git.savannah.gnu.org/gitweb/?p=tar.git;a=commit;h=6ccb513
[3] http://git.savannah.gnu.org/gitweb/?p=tar.git;a=commit;h=caf6047
[4] http://git.savannah.gnu.org/gitweb/?p=tar.git;a=commit;h=620a136
[5] http://git.savannah.gnu.org/gitweb/?p=tar.git;a=commit;h=c9a7297
[6] http://git.savannah.gnu.org/gitweb/?p=tar.git;a=commit;h=c9a7297
[7] http://git.savannah.gnu.org/gitweb/?p=tar.git;a=commit;h=c10830a

Linus Torvalds wrote:
> Do people really care about the old-fashioned tar.gz and patch.gz
> files? I've always uploaded the tar-files and patches compressed with
> gzip, because that's the "traditional" way, and then we have a script
> that also re-compresses things as 'bz2' because it compresses better
> and many people are bandwidth-limited and much prefer the better
> compression.

I prefer bzip2 or better, but then again, I'm usually working in GNU
environments.

Mark Lord wrote:
> what about the new lz thing?
> (heck haven't even figured that out yet).

Have a look at:

- http://en.wikipedia.org/wiki/Xz
- http://tukaani.org/xz/format.html


-- 
John Feuerstein <john@feurix.com>
