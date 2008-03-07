Return-Path: <linux-kernel-owner+w=401wt.eu-S1761838AbYCGSbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761838AbYCGSbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 13:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757618AbYCGSa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 13:30:58 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55114 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757037AbYCGSa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 13:30:57 -0500
Date: Fri, 7 Mar 2008 12:30:52 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Greg KH <greg@kroah.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       menage@google.com, sukadev@us.ibm.com
Subject: Re: [PATCH 5/9] Make use of permissions, returned by kobj_lookup
Message-ID: <20080307183052.GB3898@sergelap.austin.ibm.com>
References: <20080307173542.GA2552@sergelap.austin.ibm.com> <757539.74589.qm@web36608.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <757539.74589.qm@web36608.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Casey Schaufler (casey@schaufler-ca.com):
> 
> --- "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> 
> > ...
> > 
> > Until user namespaces are complete, selinux seems the only good solution
> > to offer isolation.
> 
> Smack does it better and cheaper. (Unless you define good==selinux)
> (insert smiley)

Ah, thanks - I hadn't looked into it, but yes IIUC smack should
definately work.  I'll have to give that a shot.

(A basic selinux policy module to isolate a container was pretty simple,
but providing finer-grained intra-container access seems to take some
changes to the base refpolicy.  I've been waiting a few weeks to find
time to work on that.)

thanks,
-serge
