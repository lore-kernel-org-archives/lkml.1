Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbYB1MdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbYB1MdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 07:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbYB1MdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 07:33:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbYB1MdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:33:04 -0500
Date: Thu, 28 Feb 2008 09:31:50 -0300
From: Fabio Olive Leite <fleite@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [autofs] [PATCH 3/4] autofs4 - track uid and gid of last mount requestor
Message-ID: <20080228123150.GA3915@sleipnir.redhat.com>
Mail-Followup-To: Ian Kent <raven@themaw.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	autofs mailing list <autofs@linux.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Pavel Emelyanov <xemul@openvz.org>
References: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net> <Pine.LNX.4.64.0802261208400.8490@raven.themaw.net> <20080227204546.72e16e8d.akpm@linux-foundation.org> <1204179747.3501.21.camel@raven.themaw.net> <20080227223734.caab0165.akpm@linux-foundation.org> <1204182500.3501.49.camel@raven.themaw.net> <47C667EC.6060700@openvz.org> <20080227235952.70a31d9f.akpm@linux-foundation.org> <1204185971.3501.87.camel@raven.themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1204185971.3501.87.camel@raven.themaw.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 05:06:11PM +0900, Ian Kent wrote:
> 
> Dumb old me, I really only need the uid.
> The gid can come from the get user info functions of glibc.

In case the process was executed from a setgid executable, you might
have a different gid from what the user has. In fact, I don't know why
you may need more than the pid, since with the pid you can get to the
task's effective uid/gid and maybe other such information you need.

Cheers,
Fábio Olivé
-- 
ex sed lex awk yacc, e pluribus unix, amem
