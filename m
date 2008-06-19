Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbYFSWP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbYFSWP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 18:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbYFSWPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 18:15:51 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:53270 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbYFSWPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 18:15:51 -0400
Date: Thu, 19 Jun 2008 15:08:53 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [RFC][PATCH] configfs: Report errors in
	config_*_init_type_name()
Message-ID: <20080619220853.GD10888@mail.oracle.com>
Mail-Followup-To: Louis Rilling <Louis.Rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <1213813851-7359-1-git-send-email-louis.rilling@kerlabs.com> <20080618202226.GG16780@ca-server1.us.oracle.com> <20080619091003.GJ30804@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080619091003.GJ30804@localhost>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 11:10:03AM +0200, Louis Rilling wrote:
> On Wed, Jun 18, 2008 at 01:22:26PM -0700, Joel Becker wrote:
> > 1) Make your changes to return errors from config_*_init_type_name(),
> >    but don't check the errors on known-safe usage (small static
> >    strings).
> 
> I don't like it very much, since users should check for the value of
> CONFIGFS_ITEM_NAME_LEN to ensure that this is a safe usage.

	Yeah, I don't much like it either.  I just threw it out there as
a possibility.

> > 2) Provide two API, one that is void and one that is not, so that
> >    known-safe usage can use the void call (and BUG_ON() if the strlen()
> >    is off), while other usage checks the errors.
> 
> Ok. What about config_*_init_type_long_name()?

	Well, that's better than any names I could come up with.  Let's
run with it.

Joel

-- 

"Every day I get up and look through the Forbes list of the richest
 people in America. If I'm not there, I go to work."
        - Robert Orben

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
