Return-Path: <linux-kernel-owner+w=401wt.eu-S1752949AbYCLQVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbYCLQVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 12:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbYCLQVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 12:21:22 -0400
Received: from web36613.mail.mud.yahoo.com ([209.191.85.30]:43116 "HELO
	web36613.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752169AbYCLQVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 12:21:21 -0400
X-YMail-OSG: NjwJjxoVM1m.Nnt_sB5Ks25e9tLi0uulPvrrqKxvw_PaHdPH51fBEV_0putcZRItoWxHAW3KTg--
X-RocketYMMF: rancidfat
Date: Wed, 12 Mar 2008 09:21:20 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 5/9] Make use of permissions, returned by kobj_lookup
To: Stephen Smalley <sds@tycho.nsa.gov>, "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       menage@google.com, sukadev@us.ibm.com,
       Al Viro <viro@zeniv.linux.org.uk>,
       linux-security-module@vger.kernel.org
In-Reply-To: <1205327912.23866.228.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <390167.79798.qm@web36613.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

> 
> ...
> 
> Not sure I'm following the plot here, but please don't do anything that
> will prohibit the use of containers/namespaces with security modules
> like SELinux/Smack.  Yes, that's a legitimate use case, and there will
> be people who will want to do that - they serve different but
> complementary purposes (containers are _not_ a substitute for MAC).  We
> don't want them to be exclusive of one another.

I agree that we ought to be able to (dare I say it?) stack containers
and Smack. I have come around 180 degrees regarding the value of
module stacking and am now convinced that a general mechanism for
it would be a Good Thing. Both SELinux and Smack already provide
for stacking capabilities, and I've been asked by another project to
provide for stacking their module. The alternative to general stacking
looks more and more like each LSM providing for the modules it is
willing to stack with, and that could get painful pretty quickly.

Or, tell me why I'm wrong. I promise to listen nicely. (smiley)


Casey Schaufler
casey@schaufler-ca.com
