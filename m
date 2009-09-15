Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbZIOAtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbZIOAtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 20:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbZIOAtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 20:49:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756932AbZIOAtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 20:49:39 -0400
Subject: Re: [GIT] security / creds fixes
From: Eric Paris <eparis@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.01.0909141736520.4950@localhost.localdomain>
References: <20090914162613.9016.79225.stgit@warthog.procyon.org.uk>
	 <alpine.LRH.2.00.0909151008440.11936@tundra.namei.org>
	 <alpine.LFD.2.01.0909141736520.4950@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Sep 2009 20:49:01 -0400
Message-Id: <1252975741.2246.39.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 17:37 -0700, Linus Torvalds wrote:
> 
> On Tue, 15 Sep 2009, James Morris wrote:
> > 
> > Please pull this if you haven't pulled the other one already.
> 
> No. This is entirely broken. I get about a million
> 
> 	include/linux/selinux.h:92: warning: ‘selinux_is_enabled’ defined but not used
> 
> warnings. Very annoying.

grummble grummble, forgot the 'inline' in the !CONFIG_SECURITY_SELINUX
for selinux_is_enabled in selinux.h.....

one line patch upcoming.

-Eric

