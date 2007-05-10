Return-Path: <linux-kernel-owner+w=401wt.eu-S1759523AbXEJOv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523AbXEJOv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbXEJOvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 10:51:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:60329 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbXEJOvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 10:51:18 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Long file names in VFAT broken with iocharset=utf8
To: Albert Cahalan <acahalan@gmail.com>, Andrey Borzenkov <arvidjaar@mail.ru>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, hirofumi@mail.parknet.co.jp,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Reply-To: 7eggert@gmx.de
Date: Thu, 10 May 2007 16:49:52 +0200
References: <8ipOe-5KI-3@gated-at.bofh.it> <8ityz-2Xz-31@gated-at.bofh.it> <8iWqS-5Ba-15@gated-at.bofh.it> <8iWKp-619-29@gated-at.bofh.it> <8j4eK-QR-13@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1Hm9xo-0000vV-Po@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19zOP9ORoynCIIjt6dbAS6UrJWTtpKmmSVB/+2
 ru7TU1xK+KdwwrCMPPgMZUa9f4pn4EjZO1wCkUn+ZAnxQs8CVv
 kUOyfh+Q4QBZmiHrmg7vg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Albert Cahalan <acahalan@gmail.com> wrote:
> On 5/9/07, Andrey Borzenkov <arvidjaar@mail.ru> wrote:

>> 3. this still does not answer how can I *create* long name from within Linux.
> 
> WTF? These names are too annoying to use, even if there
> weren't this limit. Anything over about 29 characters is in
> need of a rename. (that'd be 58 bytes for you, which is OK)
> The limit is already 4 times larger than what is reasonable.

Just because you limit yourself to 80 chars minus "ls -l"-clutter, this is
no reason why I shouldn't use long filenames. If I need to handle these
filenames, I can enlarge the terminal window or read the next line.

E.g.: I have a music file named "artist - title.ext", where the artist
name is 103 characters long, using abbreviations. In order to enter that
name, I have to press seven keys, including the escape character.
There is nothing unreasonable in using that name.

If I could not use these filenames, I'd have to use e.g. numbers instead of
filenames and a database containing the mapping from name to number,
duplicating the function of a directory. That's bullsh... . You should rather
bump NAME_MAX and, if you are concerned about legacy applications, make it
optional. Having some names to be illegal becaue of their length on a
filesystem not allowing command.com metacharacters is not a problem.
-- 
Funny quotes:
3. On the other hand, you have different fingers.

Friﬂ, Spammer: EhyjCDo@iEtm.7eggert.dyndns.org TK@cvhuFFu.7eggert.dyndns.org
