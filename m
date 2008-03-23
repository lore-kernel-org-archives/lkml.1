Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbYCWPYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbYCWPYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 11:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbYCWPX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 11:23:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:50049 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYCWPX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 11:23:56 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: gcc@gcc.gnu.org
Subject: Re: [PATCH] linux/fs.h - Convert debug functions declared inline  =?koi8-r?q?=09=5F=5Fattribute=5F=5F?=((format (printf,x,y) to statement expression macros
Date: Sun, 23 Mar 2008 16:22:27 +0100
User-Agent: KMail/1.8.2
Cc: Joe Perches <joe@perches.com>, Jan Hubicka <hubicka@ucw.cz>,
       Jakub Jelinek <jakub@redhat.com>, David Rientjes <rientjes@google.com>,
       Matthew Wilcox <matthew@wil.cx>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, zadeck@naturalbridge.com
References: <1204081722.19319.405.camel@localhost> <20080228102325.GC13246@atrey.karlin.mff.cuni.cz> <1204247347.9959.31.camel@localhost>
In-Reply-To: <1204247347.9959.31.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803231622.27190.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 February 2008 02:09, Joe Perches wrote:
> But the function place_entity doesn't use it directly or indirectly.
> If the lines above are removed, the generated code for place_entity changes.

I see it all the time. Whenever I add/remove/change something
to a header, some functions grow a tiny bit, some shrink a bit.
gcc 4.2.1. Report is here:

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=29950
--
vda
