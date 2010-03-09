Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab0CIJ1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 04:27:05 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:52791 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab0CIJ1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 04:27:02 -0500
Subject: opendir() on a file???
From: Jon Masters <jonathan@jonmasters.org>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Tue, 09 Mar 2010 04:26:57 -0500
Message-ID: <1268126817.10479.643.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

Now I might be missing something, and I know I'm behind on LKML[0], but
the following isn't supposed to work in my book:

/*
 * Weird kernel test
 */

#include <sys/types.h>
#include <dirent.h>
#include <stdio.h>

int main(int argc, char **argv)
{
        DIR *dir;

        dir = opendir("foo.conf");

        if (dir)
                printf("WTF?\n");

        return 0;
}

This is on an ext4 filesystem, whereas on a box with an older kernel
this test correctly does not print "WTF?". I know some filesystems
experiment with streams and treating files as directories, etc. but I
wasn't aware that anything particular had changed recently?

The box is running almost an upstream kernel, and I can poke if I'm told
this not intended: 2.6.34-0.8.rc0.git11.fc14.x86_64.

What am I missing?

Jon.

[0] The podcast isn't dead, I'm just suffering from a cold and will be
taking a day off to recover and catch up with that sometime today.


