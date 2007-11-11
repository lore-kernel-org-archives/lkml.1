Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbXKKCRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbXKKCRl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 21:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbXKKCRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 21:17:32 -0500
Received: from web36602.mail.mud.yahoo.com ([209.191.85.19]:43020 "HELO
	web36602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751407AbXKKCRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 21:17:31 -0500
X-YMail-OSG: PgJ80TIVM1mkmMl3drni1zhpxwpxHSwOskr0uXrJA33daxvd5t7kl1QxlUiR.moGQS.sKCt3YA--
X-RocketYMMF: rancidfat
Date: Sat, 10 Nov 2007 18:17:30 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: AppArmor Security Goal
To: Crispin Cowan <crispin@crispincowan.com>,
       "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
In-Reply-To: <47363381.4030103@crispincowan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <601618.10362.qm@web36602.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Crispin Cowan <crispin@crispincowan.com> wrote:

> Dr. David Alan Gilbert wrote:
> ...
>
> Can you explain why you want a non-privileged user to be able to edit
> policy? I would like to better understand the problem here.
> 
> Note that John Johansen is also interested in allowing non-privileged
> users to manipulate AppArmor policy, but his view was to only allow a
> non-privileged user to further tighten the profile on a program. To me,
> that adds complexity with not much value, but if lots of users want it,
> then I'm wrong :)

Now this is getting interesting. It looks to me as if you've implemented
a mandatory access control scheme that some people would like to be able
to use as a discretionary access control scheme. This is creepy after
seeing the MCS implementation in SELinux, which is also a DAC scheme
wacked out of a MAC scheme. Very interesting indeed.


Casey Schaufler
casey@schaufler-ca.com
