Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbZCaFvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbZCaFvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 01:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbZCaFvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 01:51:22 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:62460 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbZCaFvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 01:51:21 -0400
Message-ID: <49D1AF5B.6090006@lougher.demon.co.uk>
Date: Tue, 31 Mar 2009 06:51:23 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Rob Landley <rob@landley.net>,
       linux-kernel@vger.kernel.org, squashfs-devel@lists.sourceforge.net
Subject: Re: Squashfs 4.0 tools
References: <20090323180808.2c2ef1a7@nehalam>	<49C847C6.4030904@lougher.demon.co.uk>	<200903281727.52929.rob@landley.net>	<10f740e80903290202h1f36b370ga39721536d52a90@mail.gmail.com> <20090330175524.4e8f802e@nehalam>
In-Reply-To: <20090330175524.4e8f802e@nehalam>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> On Sun, 29 Mar 2009 11:02:19 +0200
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
>> On Sun, Mar 29, 2009 at 00:27, Rob Landley <rob@landley.net> wrote:
>>> P.S I notice a squashfs-devel mailing list cc'd here, but there's no link to
>>> it from the squashfs.org page.  Buried in the middle of a lot of text is a
>>> link to the sourceforge squashfs project page, which has a link to "forums"
>>> which are not the same as mailing lists.
>> There should be a link to it somewhere on the SF project page...
>>
>>> But it might be nice to at least _hint_ about its existence on the web page.
>>> The main page's "contact" section is your personal email and nothing else...

Squashfs is a sourceforge project, and it has a link to the main sourceforge
page from the webpage.  I've always thought that sufficient because users
can get to the mailing lists, web forum, bug tracker etc. from that, and then
choose what they think is the most appropriate way to report issues.

Missing information is simply that, and I rely on feedback from users to
say if I've forgotten to add important or relevant information anywhere.
It would be helpful if that feedback didn't include an implied
criticism, that way we'll all get along better.

> 
> I built it from cvs (imported into git), and it works okay.
> 

Good, this is what I suggested you do :-)  CVS contains everything I've
been working on for the last couple of months.

I intended to do a release last week, but, release testing found a number
of bugs and other issues which had to be addressed, and which consequently
delayed the release.

If you grabbed the tools from CVS more than a day ago you'll find
there's problems with Unsquashfs and big-endian systems.  The last
bug fix (a deadlock issue in mksquashfs undiscovered since 3.4)
went in just now, and so CVS should be what's in the release.

BTW Stephen, it would be helpful if you subscribed to the
squashfs-devel mailing list, at the moment I've having to
authorise all your posts which is a bit of a pain.

Phillip
