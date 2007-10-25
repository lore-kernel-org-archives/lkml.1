Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbXJYS7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbXJYS7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 14:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbXJYS7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 14:59:00 -0400
Received: from web36604.mail.mud.yahoo.com ([209.191.85.21]:42139 "HELO
	web36604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753183AbXJYS67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 14:58:59 -0400
X-YMail-OSG: tQHxTkoVM1kNJkZ3gXpVQNpciYrMWbNiYs5UCdu6EMZUlxNDnAPCWx0wQWxBlQp8j5ewbJc47w--
X-RocketYMMF: rancidfat
Date: Thu, 25 Oct 2007 11:58:58 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 2/2] Version 9 (2.6.24-rc1) Smack: Simplified Mandatory Access Control Kernel
To: Stephen Smalley <sds@tycho.nsa.gov>, casey@schaufler-ca.com
Cc: akpm@osdl.org, torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1193324834.2683.113.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <551347.37651.qm@web36604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

> On Wed, 2007-10-24 at 20:46 -0700, Casey Schaufler wrote:
> ...
> > +Smack does not implement Domain Type Enforcement (DTE). If
> > +you want DTE Linux has an implementation called SELinux.
> > +Those who really want DTE are encouraged to use SELinux.
> > +Those who don't know what DTE is are encouraged to compare
> > +SELinux with Smack to determine which mechanisms are best
> > +suited to the problem at hand.
> 
> Nit: SELinux does not implement DTE.  DTE was a scheme introduced by Lee
> Badger et al to apply implicit typing based on pathname as a variant of
> the original type enforcement model.  SELinux is an implementation of
> the Flask security architecture for flexible MAC, along with an example
> security server that implements RBAC, TE, and MLS models, but not
> limited to them.

Okey Dokey. I'll fix that up.

Thank you for the review. I will have a look at all of the
individual comments.



Casey Schaufler
casey@schaufler-ca.com
