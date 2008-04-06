Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbYDFUXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbYDFUXP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 16:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbYDFUXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 16:23:00 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:35394 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbYDFUW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 16:22:59 -0400
Date: Sun, 6 Apr 2008 13:22:58 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: Alexander van Heukelum <heukelum@fastmail.fm>
cc: Alexander van Heukelum <heukelum@mailshack.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: generic versions of find_first_(zero_)bit, convert
     i386
In-Reply-To: <1207507897.18129.1246358115@webmail.messagingengine.com>
Message-ID: <alpine.DEB.1.10.0804061320470.7751@twinlark.arctic.org>
References: <20080331171506.GA24017@mailshack.com> <20080401084710.GB4787@elte.hu>      <20080401094618.GA24862@mailshack.com>      <alpine.DEB.1.10.0804060958580.7751@twinlark.arctic.org> <1207507897.18129.1246358115@webmail.messagingengine.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Apr 2008, Alexander van Heukelum wrote:

> The current generic implementation of ffz is O(lg(n)) already

it's O(lg(n)) time... the operations all depend on each other.

the implementation i pointed to is O(lg(n)) code space... and the time 
depends on how parallel the machine is, they're not dependent on each 
other.

-dean
