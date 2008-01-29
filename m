Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbYA2WXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbYA2WXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 17:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbYA2WWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 17:22:55 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:24446 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbYA2WWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 17:22:54 -0500
Date: Tue, 29 Jan 2008 14:22:39 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Greg KH <gregkh@suse.de>, Mark Fasheh <mark.fasheh@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: Re: [git pull] Fix recent Ocfs2 breakage
Message-ID: <20080129222239.GB27902@mail.oracle.com>
Mail-Followup-To: Greg KH <gregkh@suse.de>,
	Mark Fasheh <mark.fasheh@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <20080129033307.GE23506@ca-server1.us.oracle.com> <20080129050804.GA2285@suse.de> <20080129074402.GA27097@ca-server1.us.oracle.com> <20080129185448.GA358@suse.de> <20080129221858.GA27902@mail.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129221858.GA27902@mail.oracle.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 02:18:58PM -0800, Joel Becker wrote:
> 	But I'm still not understanding what you mean by "1 kobject for
> the directory".  We have one kobject for the "logmask" directory, and
> then attributes for each log type.  I don't see how that would change.

	Oh, wait, I'm an idiot.  It does look like its a kset.  If we
set the ktype to have the ops and attrs, just like we do, but use a
kobj, would that make you happier?

Joel

-- 

"The whole problem with the world is that fools and fanatics are always
 so certain of themselves, and wiser people so full of doubts."
	- Bertrand Russell

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
