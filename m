Return-Path: <linux-kernel-owner+w=401wt.eu-S1766884AbXDSROz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766884AbXDSROz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 13:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161510AbXDSROz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 13:14:55 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:64118 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161506AbXDSROx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 13:14:53 -0400
Subject: Re: AppArmor FAQ
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Crispin Cowan <crispin@novell.com>
Cc: James Morris <jmorris@namei.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>,
       Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <4626746A.9010701@novell.com>
References: <20070417181016.GA10903@one.firstfloor.org>
	 <657751.18080.qm@web36614.mail.mud.yahoo.com>
	 <20070417211653.GB11944@one.firstfloor.org>
	 <20070417225815.000b0fdb@the-village.bc.nu>
	 <Line.LNX.4.64.0704180935100.25495@d.namei>  <4626746A.9010701@novell.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 19 Apr 2007 13:14:18 -0400
Message-Id: <1177002858.27654.119.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-18 at 12:41 -0700, Crispin Cowan wrote:
> James Morris wrote:
> > On Tue, 17 Apr 2007, Alan Cox wrote:
> >   
> >> I'm not sure if AppArmor can be made good security for the general case,
> >> but it is a model that works in the limited http environment
> >> (eg .htaccess) and is something people can play with and hack on and may
> >> be possible to configure to be very secure.
> >>     
> > Perhaps -- until your httpd is compromised via a buffer overflow or 
> > simply misbehaves due to a software or configuration flaw, then the 
> > assumptions being made about its use of pathnames and their security 
> > properties are out the window.
> >   
> How is it that you think a buffer overflow in httpd could allow an
> attacker to break out of an AppArmor profile? This is exactly what
> AppArmor was designed to do, and without specifics, this is just FUD.
> 
> > Without security labeling of the objects being accessed, you can't protect 
> > against software flaws, which has been a pretty fundamental and widely 
> > understood requirement in general computing for at least a decade.
> >   
> Please explain why labels are necessary for effective confinement. Many
> systems besides AppArmor have used non-label schemes for effective
> confinement: TRON, Janus, LIDS, Systrace, BSD Jail, EROS, PSOS, KeyOS,
> AS400, to name just a few. This claim seems bogus. Labels may be your
> method of choice for confinement, but they are far from the only way.

Confinement in its traditional sense (e.g. the 1973 Lampson paper, ACM
Vol 16 No 10) means information flow control, which you have agreed
AppArmor does not and cannot provide.  Yes?  As to the (genuine)
capability-based systems, have a look at the DTOS General System
Security and Assurability Assessment Report for why we have concerns
with their approach.  But that has nothing to do with AppArmor.

Look, if you would just refrain from making misleading statements about
SELinux (not only in this FAQ but throughout your documents and talks),
especially when we've previously refuted those same statements (as in
the first AppArmor submission and its discussion), and honestly
acknowledged the limitations of your approach without trying to spin
them as strengths, I think that there would be nothing to discuss here.
We could just agree to disagree, and you could just focus on addressing
the issues raised by the vfs folks about how to get your changes into an
acceptable form.

-- 
Stephen Smalley
National Security Agency

