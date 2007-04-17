Return-Path: <linux-kernel-owner+w=401wt.eu-S1031261AbXDQVvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031261AbXDQVvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 17:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031263AbXDQVvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 17:51:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031261AbXDQVvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 17:51:44 -0400
Subject: Re: AppArmor FAQ
From: Karl MacMillan <kmacmill@redhat.com>
To: casey@schaufler-ca.com
Cc: Andi Kleen <andi@firstfloor.org>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <657751.18080.qm@web36614.mail.mud.yahoo.com>
References: <657751.18080.qm@web36614.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Tue, 17 Apr 2007 17:48:27 -0400
Message-Id: <1176846507.5946.70.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-17 at 13:19 -0700, Casey Schaufler wrote:
> --- Andi Kleen <andi@firstfloor.org> wrote:
> > > although this can often be done with PAM plugins, which is a standard way 
> > > to do this kind of thing in modern Unix & Linux OSs.
> > 
> > PAM plugins in vi and emacs? Scary idea.
> > 
> > And what do you do if someone decides to use OpenOffice to edit their
> > /etc/resolv.conf? For a lot of people that's the only text editor 
> > they know.
> 
> For SELinux to be effective it has to have a complete policy definition.
> This would prevent the OpenOffice access (unless OpenOffice is in the
> modify_resolv_conf_t domain) above.
> 
> This, by the way, is a fundimental advantage of a path scheme over a
> label scheme in that label schemes require every object be labeled
> (it's Section 3.1.1.3 of the TCSEC if you want to look it up) while a
> path scheme (in the absences of a published requirement) only requires
> those names it cares about. SELinux in the absence of a correct and
> complete policy could be considered dangerous.
> 

This is wildly untrue (as I believe you know Casey). The effectiveness
of SELinux is certainly diminished by not confining all applications,
but that in no way makes it dangerous. It simply means that certain
aspects of the security are no longer guaranteed by the policy but
instead rely on application correctness. SELinux still offers useful
protections against a variety security threats in a targeted
configuration.

This is in contrast to a security mechanism that is path based and
doesn't control all accesses which can make _no_ guarantees about any
security goals. 

Karl

