Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbZIOAiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbZIOAiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 20:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757633AbZIOAiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 20:38:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754717AbZIOAiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 20:38:10 -0400
Date: Mon, 14 Sep 2009 17:37:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: James Morris <jmorris@namei.org>
cc: Eric Paris <eparis@redhat.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT] security / creds fixes
In-Reply-To: <alpine.LRH.2.00.0909151008440.11936@tundra.namei.org>
Message-ID: <alpine.LFD.2.01.0909141736520.4950@localhost.localdomain>
References: <20090914162613.9016.79225.stgit@warthog.procyon.org.uk> <alpine.LRH.2.00.0909151008440.11936@tundra.namei.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Sep 2009, James Morris wrote:
> 
> Please pull this if you haven't pulled the other one already.

No. This is entirely broken. I get about a million

	include/linux/selinux.h:92: warning: ¡selinux_is_enabled¢ defined but not used

warnings. Very annoying.

		Linus
