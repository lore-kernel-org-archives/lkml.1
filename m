Return-Path: <linux-kernel-owner+w=401wt.eu-S1031292AbXDQXMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031292AbXDQXMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 19:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031295AbXDQXMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 19:12:30 -0400
Received: from web36603.mail.mud.yahoo.com ([209.191.85.20]:31255 "HELO
	web36603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031291AbXDQXM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 19:12:29 -0400
X-YMail-OSG: TKnaLZIVM1nqNFrXBgsfqjI7Sa4pyWjmBK4MwAZZL6ksOv2qvyuzSsSMYlOAEIGX6ARuMmiI4A--
X-RocketYMMF: rancidfat
Date: Tue, 17 Apr 2007 16:12:28 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: AppArmor FAQ
To: Karl MacMillan <kmacmill@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <1176846507.5946.70.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <680990.15666.qm@web36603.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Karl MacMillan <kmacmill@redhat.com> wrote:

> On Tue, 2007-04-17 at 13:19 -0700, Casey Schaufler wrote:
> > --- Andi Kleen <andi@firstfloor.org> wrote:
> > > > although this can often be done with PAM plugins, which is a standard
> way 
> > > > to do this kind of thing in modern Unix & Linux OSs.
> > > 
> > > PAM plugins in vi and emacs? Scary idea.
> > > 
> > > And what do you do if someone decides to use OpenOffice to edit their
> > > /etc/resolv.conf? For a lot of people that's the only text editor 
> > > they know.
> > 
> > For SELinux to be effective it has to have a complete policy definition.
> > This would prevent the OpenOffice access (unless OpenOffice is in the
> > modify_resolv_conf_t domain) above.
> > 
> > This, by the way, is a fundimental advantage of a path scheme over a
> > label scheme in that label schemes require every object be labeled
> > (it's Section 3.1.1.3 of the TCSEC if you want to look it up) while a
> > path scheme (in the absences of a published requirement) only requires
> > those names it cares about. SELinux in the absence of a correct and
> > complete policy could be considered dangerous.
> > 
> 
> This is wildly untrue (as I believe you know Casey).

Is it? In an environment with automatic domain transitions and
socket based administrative interfaces I can easily imagine how
an incorrect or incomplete policy definition (or even one containing
an ill advised regular expression in a pathname) could result in
a user being able to get inappropriate service from an application.
Maybe I am being silly. I am part of the generation that treats
the setuid bit gingerly, and one of the people who worked to see that
the POSIX capability mechanism was appropriately careful. The notion
of applications flipping their security contexts about based on
externally specified rules in an environment where communications
with potentially privileged processes are covered by another set
of those rules does not inspire confidence. I think that those rules
had better be very carefully defined for them to be worthy of trust.

> The effectiveness
> of SELinux is certainly diminished by not confining all applications,
> but that in no way makes it dangerous. It simply means that certain
> aspects of the security are no longer guaranteed by the policy but
> instead rely on application correctness. SELinux still offers useful
> protections against a variety security threats in a targeted
> configuration.

OK, if it make you feel secure, that's fine. It doesn't do anything
for me.

> This is in contrast to a security mechanism that is path based and
> doesn't control all accesses which can make _no_ guarantees about any
> security goals. 

But ... in a targeted policy SELinux isn't controlling all accesses, either.
Well, there's really no point it making further arguements. I don't
expect to get through where I've failed before. And SELinux is still the
best type enforcement scheme available, so if you like that sort of thing
it's a fine choice. I still don't think that the arguments against path
based access are particularly compelling.


Casey Schaufler
casey@schaufler-ca.com
