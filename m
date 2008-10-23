Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbYJWHzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbYJWHzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 03:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYJWHy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 03:54:59 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:44383 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbYJWHy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 03:54:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=UCISTL6W2RzKMYPH9tJtrSubUujJcPTGRGajz/0GNrM0sHKV7rvmst5GKVSY71wceO
         YqVJzm47/TUl36SRsxt1RHa/fhjDOlREQcOWZJO9VcG7iTu3BNeMHGGPAErku3jcKF9b
         6ixawDlZS9U3aU+7JJ1EPubhf0OXrZi9+NqNw=
Message-ID: <6ffd69180810230054s3b6aff5y880a898c3fc66a37@mail.gmail.com>
Date: Thu, 23 Oct 2008 00:54:56 -0700
From: "Robert Moss" <robert.von.moss@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Framebuffer issues in 2.6.26 with uvesafb and vesafb. Linux is about choice!
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linux maintainers,

Firstly, I would like to extend my deepest appreciation for your
dedication the linux project. I use nothing but linux, and am happy to
say, I love it to death.

However, since I've installed 2.6.26, I've noticed what I believe to
be a serious detriment to the community. While in itself, its not
major, if trends like it continue...

Anyhow, I noticed that vesafb is no longer a part of the kernel. I
have debian sid, and its 2.6.26-1 kernel seemed to have
CONFIG_FB_VESA=Y in its config, but it didn't work. So I naturally
compiled my own kernel, making sure to explicitly mark Y for the
option. However, vga=791 still gave a mode not found. After much trial
and error, and googling, I was able to get uvesafb working, however,
it doesn't start until later in the boot sequence (unfavorable), and
also, with splashy, the background image is stretched vertically over
500% showing only an ugly top portion of the image.

Now I could care less about the splash screen, its the principle. I
spent days working on trying different things, researching, and
compiling, all to no avail. I don't understand why you couldn't leave
vesafb in there (and if it is in there, its terribly broken) And
uvesafb is a serious pain to get set up for someone with an advanced
level of experience, and out of reach for newcomers and even those
who've mastered Windoze machines and are fresh converts.

For the time being, I am using 2.6.24, because linux works like its
supposed to here. Right after grub, the framebuffer kicks in (and
while uvesafb might be nice, with extra features, having to wait for
it is not) and next thing I know, splashy works fine, more
importantly, pidgin (finch) and links work in the framebuffer console
(which also work once I finally got uvesafb working, but it was hardly
worth it).

Until uvesafb matures to the point that it can be a valid replacement
for vesafb, don't do it, and when that day comes, let users have a
choice.

Thank you for hearing my concerns, and keep up the good work.


p.s., I'm currently starting work on a patch to get vesafb back up and
working on 2.6.26, but thats neither here nor there, give those that
cannot help themselves with code the choice they come to linux for!
