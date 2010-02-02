Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab0BBSKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 13:10:13 -0500
Received: from alt.dspnet.fr.eu.org ([213.186.44.138]:4240 "EHLO
	dspnet.fr.eu.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756335Ab0BBSKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 13:10:10 -0500
Date: Tue, 2 Feb 2010 19:10:07 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] %pd - for printing dentry name
Message-ID: <20100202181007.GA75577@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20100201222511.GA12882@ZenIV.linux.org.uk> <alpine.LFD.2.00.1002011431490.3664@localhost.localdomain> <20100201231847.GC12882@ZenIV.linux.org.uk> <20100202010653.GD12882@ZenIV.linux.org.uk> <m1k4uwfag1.fsf@fess.ebiederm.org> <20100202170157.GH12882@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202170157.GH12882@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 05:01:57PM +0000, Al Viro wrote:
> + * - 'd' For dentry name.  NOTE: don't use under dentry->d_lock, there
> + *       you can safely use ->d_name.name instead.

You probably can get rid of the caveat, then, right?  "Don't use
d_name.name in printk" is easier to grep for :-)

  OG.

