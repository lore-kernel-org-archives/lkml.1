Return-Path: <linux-kernel-owner+w=401wt.eu-S933385AbXBET1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933385AbXBET1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 14:27:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933414AbXBET1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 14:27:03 -0500
Received: from web36602.mail.mud.yahoo.com ([209.191.85.19]:29085 "HELO
	web36602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933416AbXBET1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 14:27:01 -0500
X-YMail-OSG: 1aWeXiMVM1lJuPNlc6naebv0911szxRwyO6XCcCx
X-RocketYMMF: rancidfat
Date: Mon, 5 Feb 2007 11:26:39 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
To: Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>, linux-security-module@vger.kernel.org,
       agruen@suse.de
In-Reply-To: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <101270.11571.qm@web36602.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Tony Jones <tonyj@suse.de> wrote:

> Introduction
> ------------
> 
> The following are a set of patches the goal of which
> is to pass vfsmounts
> through select portions of the VFS layer sufficient
> to be visible to the LSM
> inode operation hooks.



> 
> They are being posted now as a request for comment. 
> Presently the AppArmor
> code - being a user of the LSM interface - does not
> receive the vfsmount 
> correspoding to an operation and has to employ
> convoluted and slow mechanisms 
> in an attempt to determine the vfsmount which are
> error prone.

Would it be possible for you to describe those
methods? Perhaps there is a better way to go
about getting the information you need without
introducing this level of change.



Casey Schaufler
casey@schaufler-ca.com
