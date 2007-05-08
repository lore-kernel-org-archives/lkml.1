Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbXEHWLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbXEHWLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbXEHWLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:11:11 -0400
Received: from lazybastard.de ([212.112.238.170]:46075 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbXEHWLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:11:10 -0400
Date: Wed, 9 May 2007 00:06:45 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Albert Cahalan <acahalan@gmail.com>
Cc: akpm@osdl.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       shaggy@linux.vnet.ibm.com, dgc@sgi.com, Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 0/2] LogFS take two
Message-ID: <20070508220642.GF23056@lazybastard.org>
References: <787b0d920705072253vd9eb7c4o893412d28706c9a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <787b0d920705072253vd9eb7c4o893412d28706c9a6@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 01:53:38 -0400, Albert Cahalan wrote:
> 
> You seem to be missing the immutable bit. This is really useful
> for dealing with buggy or badly-designed things running as root.
> I've used to to protect /dev/null from becoming a normal file
> filled with junk, and to protect /etc/resolv.conf from "helpful"
> network management daemons that don't know my DNS servers.

Sounds useful.  Onto my todo list.  And since the list is slowly getting
too long to be memorized, I've added it to my wiki:
http://logfs.org/logfs/todo

> Anything else missing?
> 
> BTW, BSD offers an unprivileged immutable bit as well. I'm sure
> it's useful for the apps that trash their own config files.
> Actually, this bit alone would do fine, and we could really use
> a way to protect writable device files from deletion or permission
> bit changes.

It would be relatively easy to add this as well.  The biggest obstacle I
see is getting support in chattr(1).  Adding Ted to Cc:, as he is the
maintainer.

What remains to be decided is whether such a flag is a useful addition.
My gut feeling is yes, but I would like to have more than two votes in
favor.

Jörn

-- 
Fools ignore complexity.  Pragmatists suffer it.
Some can avoid it.  Geniuses remove it.
-- Perlis's Programming Proverb #58, SIGPLAN Notices, Sept.  1982
