Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbXFNKxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbXFNKxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 06:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbXFNKxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 06:53:23 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:42681 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751235AbXFNKxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 06:53:22 -0400
Subject: Re: [RFC] TOMOYO Linux
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "william(at)elan.net" <william@elan.net>
Cc: Toshiharu Harada <haradats@gmail.com>, Rik van Riel <riel@redhat.com>,
       Toshiharu Harada <haradats@nttdata.co.jp>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <Pine.LNX.4.62.0706131631280.1344@sokol.elan.net>
References: <466FA71C.1020309@nttdata.co.jp>
	 <1181743635.17547.350.camel@moss-spartans.epoch.ncsc.mil>
	 <9d732d950706130722g12a22604p223381a8e281a4a1@mail.gmail.com>
	 <46704D49.8010308@redhat.com>
	 <9d732d950706131435s636b852di98026aed1d9a6ac6@mail.gmail.com>
	 <467064B9.1080005@redhat.com>
	 <9d732d950706131525n667587e6t59e94c5cee951c6d@mail.gmail.com>
	 <Pine.LNX.4.62.0706131631280.1344@sokol.elan.net>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 14 Jun 2007 06:53:04 -0400
Message-Id: <1181818384.17547.546.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-13 at 16:32 -0700, william(at)elan.net wrote:
> On Thu, 14 Jun 2007, Toshiharu Harada wrote:
> 
> > 2007/6/14, Rik van Riel <riel@redhat.com>:
> >> Toshiharu Harada wrote:
> >> > 2007/6/14, Rik van Riel <riel@redhat.com>:
> >> > SELinux has a well designed robust and flexible functions.
> >> > So it should be used for everywhere.  I understand it.
> >> > As you mentioned one can analyze the system (process)
> >> > behaviors from AVC logs. But the maintenance cost is not trivial.
> >> >
> >> > If logging with process context is the only purpose,
> >> > current TOMOYO Linux can do it with no hustle at all.
> >> 
> >> Yes, but so does standard SELinux.
> >> 
> >> You are making me curious: what does TOMOYO do that is
> >> not done by regular SELinux?
> >> 
> >> Logging with process name, path name and contexts is
> >> already done.  I must have missed some other TOMOYO
> >> feature in your initial email...
> >
> > I see SELinux can log with process name, path name and
> > contexts, but "contexts" must be defined beforehand.
> > TOMOYO Linux kernel does that with pathname, so no
> > label definitions needed.
> > You can confirm the process (domain) transitions any time
> > and access occurred are clarified per domain basis automatically.
> > Security context in TOMOYO Linux is represented and stored
> > as a call chain and very intuitive.
> >
> > TOMOYO Linux has a mode called "learning"
> > in addition to "permissive" and "enforce". You can easily
> > get the TOMOYO Linux policy with learning mode that
> > SELinux does not have. In addition, access control mode of
> > TOMOYO Linux can be managed for every difference domain.
> 
> This sounds a like like feature differences "compared" at:
>   http://www.novell.com/linux/security/apparmor/selinux_comparison.html

Amazing, per that table, AppArmor is better in every way than SELinux.
Nothing like an unbiased and fair-minded comparison.

-- 
Stephen Smalley
National Security Agency

