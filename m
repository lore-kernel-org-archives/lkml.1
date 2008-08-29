Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbYH2LLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbYH2LLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 07:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbYH2LLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 07:11:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52110 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbYH2LLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 07:11:47 -0400
Date: Fri, 29 Aug 2008 12:11:46 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: kovlensky@interia.pl
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mounting windows shares with path exactly like on windows
Message-ID: <20080829111146.GJ28946@ZenIV.linux.org.uk>
References: <20080829105420.E10967E8036@f17.poczta.interia.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080829105420.E10967E8036@f17.poczta.interia.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 12:54:20PM +0200, kovlensky@interia.pl wrote:
> All,
> 
> Thank you for massive support. First - all of you miss one important issue - slash/backlash conversion, when transferring path from Linux to Windows and back. Second - that's corporate with tens of people relying on these systems running. Answering questions about application - that's big engineering one, with port existing on many os'es. Objects, which are created there, point to physical files on disk. It's like symlink. One symlink per object. As these symlinks are simply single paths to file I find it impossible to develop any method of having a link working on both Linux and Windows. Also writing anything on my own won't work - I know that it can be done with LD_PRELOAD for example, but try convincing big corporation that their development-critical environment can safely rely on your custom piece of code...
 
If they have port to many OSes, they have dealt with that before and
solution used for e.g. Solaris would very likely be a good start...
