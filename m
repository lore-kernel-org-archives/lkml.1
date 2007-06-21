Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbXFUVqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbXFUVqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 17:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbXFUVq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 17:46:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:54910 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbXFUVq2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 17:46:28 -0400
From: =?iso-8859-1?q?Zolt=E1n_HUBERT?= <zoltan.hubert@zzaero.com>
To: linux-kernel@vger.kernel.org,
       =?iso-8859-1?q?Zolt=E1n_HUBERT?= <zoltan.hubert@zzaero.com>
Subject: Please release a stable kernel Linux 3.0
Date: Thu, 21 Jun 2007 23:49:54 +0200
User-Agent: KMail/1.8
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706212349.54983.zoltan.hubert@zzaero.com>
X-Provags-ID: V01U2FsdGVkX1/5RD6r/4Z9OoQ0DPSIOIAUujKPQK6Z+JA3Upd
 mbJGG8b8LKNC7xjkIOm4Rs+6iXjs+rZkWollCFNjflOeMfjRKl
 172Tej2LkNUqKd4WXN/cyLAWQm/IX6L
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello gentlemen (and ladies ?)

As a power-user (NOT a hacker) I kindly ask you to please 
change the naming scheme and come back to the traditional 
model, and release a stable kernel while working on a 
develoment branch.

I'm not on the [lkml] so should you answer please CC my 
e-mail: zoltan.hubert@zzaero.com

All people who might read this know that traditionally 
stable releases are even numbered and development branches 
are odd numbered. This changed during late develoment of 
2.6, according to my analysis because of the "invention" of 
GIT which was itself necessary because of BitKeeper (insert 
ooooooooold flame-wars here) and which allowed very dynamic 
develoment. While this has been effective, alternative 
voices (Mr Morton complaining that more bugs were added 
than repaired, semi-stable semi-supported 2.6.x.y branches 
where invented...) come more and more into the front. The 
upcoming GPL v3 versus v2 debate will make things worse, 
and we all know this. The un-ending stable ABI argument 
goes into this same direction.

So I feel that a turning-point is coming where a really 
really really (x 15) stable and reliable kernel is NEEDED.

You might think it's easy for me to simply "use" Linux and 
complain while you're doing the hard stuff. As it happens, 
the current development/stable model makes our life as 
"users" more and more difficult. I'm using Linux since 1997 
on a Mac thanks to LinuxPPC-1997, and I'm a hard pusher of 
Linux whenever possible, sometimes against the common 
sense, for example when I favor using National Instrument 
cards with Linux drivers and custom written TCP/IP server 
against easy LabView on Windows. While some of you dislike 
closed source drivers, the choices "we users" face are:
- closed source drivers with closed source OS
- closed source drivers with open source OS
Please consider that we are living in a REAL world, and not 
Disney-Land.



So I've demonstrated that from a "users" perspective a new 
stable Linux would be of advantage. I'll now list what I 
suggest for this new stable branch:

First, there are some fundamental ideas in the pipelines of 
forthcoming releases which should be part of the next 
"stable" Linux (Reiser4, the new scheduler from Mr. Molnár, 
virtualisation...). So any next stable kernel branch should 
include most of these recent developments, with the goal of 
stabilising them. May-be a poll on [lkml] as to which 
feature to include or not would help ?

Second, there was once a suggestion that 2.6 should be 3.0 
since a lot of things changed:
- modules called .ko and not .o
- the output of the compile
- ... (I don't remember)
This was a brilliant suggestion and I whish another 
consideration was given to that idea. You might even go a 
step further and call kernel modules .kmod. Why on earth 
call "kernel object" things that are "kernel modules" ? And 
that every person calls "modules" and not "objects" ? I 
know I know, in UNIX dynamic libraries are .so "shared 
objects", so what ? A "module" is a "module" and NOT an 
"object", call a cat a cat.

Third, while a stable ABI in a dynamically developed kernel 
is a difficult/impossible/unwanted feature, it should be 
possible to implement in a stable branch. This could even 
be a distinction between "stable" and "development" 
branches. And it would certainly help vendors of 
closed-source drivers.

Fourth, a finnish developper on this list suggested several 
times that people should be allowed to try stupid things. 
Well, I'm doing just that.



As a conclusion, please, please, consider splitting again 
the kernel in 2 distinct branches, one labeled 
"development" suiting your needs and another labeled 
"stable" for us users.

Sincerely yours,

Zoltán.





-- 
 
________________________

Zoltan
________________________

 
