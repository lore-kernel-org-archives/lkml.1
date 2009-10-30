Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbZJ3UhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbZJ3UhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 16:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757409AbZJ3UhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 16:37:23 -0400
Received: from smtp-noauth7.primus.ca ([216.254.180.38]:56975 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756885AbZJ3UhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 16:37:22 -0400
Date: Fri, 30 Oct 2009 16:37:15 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, Jan Kara <jack@suse.cz>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       jamie@shareable.org
Subject: Re: symlinks with permissions
Message-ID: <20091030203715.GA28901@emergent.ellipticsemi.com>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	Jan Kara <jack@suse.cz>, "J. Bruce Fields" <bfields@fieldses.org>,
	"Serge E. Hallyn" <serue@us.ibm.com>,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
	jamie@shareable.org
References: <1256579869.8576.7.camel@heimdal.trondhjem.org>
 <20091025093604.GA1501@ucw.cz>
 <m1zl7cb1c5.fsf@fess.ebiederm.org>
 <20091028081653.GA18290@elf.ucw.cz>
 <m1k4yfkbfg.fsf@fess.ebiederm.org>
 <20091028210323.GA4159@elf.ucw.cz>
 <m1hbtj7xgj.fsf@fess.ebiederm.org>
 <20091029110344.GA1517@ucw.cz>
 <m1d4466uel.fsf@fess.ebiederm.org>
 <20091030183559.GF7008@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091030183559.GF7008@elf.ucw.cz>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19:35 Fri 30 Oct     , Pavel Machek wrote:
> > How many linux shell scripts and other applications that use /dev/fd/N
> > or /proc/self/fd/N will you be breaking?
> 
> Zero. (Well unless someone is exploiting it in wild).

I've definitely written at least one script before that does something
along the lines of 'echo foo > /dev/fd/N'.  It's not one that I remember
anything else about, so perhaps its behaviour would be unaffected by
forbidding this if the particular file descriptor did not originally
have read-write permissions.  I have a hard time believing that amongst
millions of users, not one of them has a script that would be affected.

Frankly, I don't understand what is particularly surprising about the
fact that people can write to files with world write permissions.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

