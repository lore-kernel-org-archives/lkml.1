Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbZDVUAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbZDVUAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbZDVT71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:59:27 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3553 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbZDVT70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:59:26 -0400
Subject: Re: [PATCH 0/10] MAINTAINERS - add script, patterns and misc
 updates
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, pavel@ucw.cz, randy.dunlap@oracle.com,
       torvalds@linux-foundation.org, akpm@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090422120510.cc17e470.akpm@linux-foundation.org>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
	 <20090417134711.ba0f03e7.randy.dunlap@oracle.com>
	 <1240003652.31116.44.camel@localhost> <20090407081312.GH1408@ucw.cz>
	 <1240415689.21848.19.camel@localhost>
	 <20090422185916.GA3864@uranus.ravnborg.org>
	 <20090422120510.cc17e470.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 12:56:25 -0700
Message-Id: <1240430185.21848.103.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-22 at 12:05 -0700, Andrew Morton wrote:
> > It is irritating to manually copy name+email as it looks today.
> > I always have to do that for the Cc: lines.
> me2

This seems to do a decent job of conversion:
I have this in my tree.  I'll submit it later.

perl -i -e 'local $/; while(<>) { s@P:	([^\n]+)\nM:	([^\n]+)\n@M:	\1 <\2>\n@g; print; }' MAINTAINERS 


