Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbYCXT6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbYCXT6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbYCXT6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:58:07 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4368 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbYCXT6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:58:05 -0400
Subject: Re: [PATCH] linux/fs.h - Convert debug functions declared inline 
	=?koi8-r?q?=09=5F=5Fattribute=5F=5F?=((format (printf,x,y) to statement
	expression macros
From: Joe Perches <joe@perches.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: gcc@gcc.gnu.org, Jan Hubicka <hubicka@ucw.cz>,
       Jakub Jelinek <jakub@redhat.com>, David Rientjes <rientjes@google.com>,
       Matthew Wilcox <matthew@wil.cx>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, zadeck@naturalbridge.com
In-Reply-To: <200803231622.27190.vda.linux@googlemail.com>
References: <1204081722.19319.405.camel@localhost>
	 <20080228102325.GC13246@atrey.karlin.mff.cuni.cz>
	 <1204247347.9959.31.camel@localhost>
	 <200803231622.27190.vda.linux@googlemail.com>
Content-Type: text/plain
Date: Mon, 24 Mar 2008 12:52:09 -0700
Message-Id: <1206388329.4845.41.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-03-23 at 16:22 +0100, Denys Vlasenko wrote:
> On Friday 29 February 2008 02:09, Joe Perches wrote:
> > But the function place_entity doesn't use it directly or indirectly.
> > If the lines above are removed, the generated code for place_entity changes.
> I see it all the time. Whenever I add/remove/change something
> to a header, some functions grow a tiny bit, some shrink a bit.
> gcc 4.2.1. Report is here:
> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=29950

This seems more like a machine descriptions or target pass defect
than an RTL problem.

Should this defect be classified in group "Target" rather than "RTL"?

