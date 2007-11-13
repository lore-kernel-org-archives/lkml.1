Return-Path: <linux-kernel-owner+w=401wt.eu-S1761139AbXKMXx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761139AbXKMXx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 18:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758133AbXKMXxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 18:53:19 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41388 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374AbXKMXxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 18:53:18 -0500
Date: Tue, 13 Nov 2007 17:53:18 -0600
From: "Serge E. Hallyn" <sergeh@us.ibm.com>
To: Chris Friedhoff <chris@friedhoff.org>
Cc: Serge E Hallyn <sergeh@us.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Posix file capabilities in 2.6.24rc2
Message-ID: <20071113235318.GA6477@sergelap.austin.ibm.com>
References: <20071113230720.22c6a036.chris@friedhoff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113230720.22c6a036.chris@friedhoff.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chris Friedhoff (chris@friedhoff.org):
> Hello,
> 
> everything works as expected, but ...
> 
> closing X and no capabilities set for xinit does shutdown only the
> windowmanager and not the X server (Xorg server 1.4)
> Consolemessage is:
> xinit:  Operation not permitted (errno 1): Can't kill X server
> 
> 
> the xattr capability is removed, when the file is chown'ed.

Hi Chris,

yes on chown the capability is removed.  I'm not quite sure what
you're asking?  Is your setup depending on being able to chown
while keeping file capabilities?  Can you give some more details?

thanks,
-serge
