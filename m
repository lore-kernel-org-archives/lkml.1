Return-Path: <linux-kernel-owner+w=401wt.eu-S1758908AbXJCVGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbXJCVGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 17:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbXJCVGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 17:06:16 -0400
Received: from web36611.mail.mud.yahoo.com ([209.191.85.28]:47129 "HELO
	web36611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754236AbXJCVGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 17:06:14 -0400
X-YMail-OSG: YPjHep4VM1kixg2ttkj1X5BGQzrEsmFRG8K5mh._E_CKNmYSUVrNJo4MVp.29geE74gq1USTJA--
X-RocketYMMF: rancidfat
Date: Wed, 3 Oct 2007 14:06:13 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 4 (2.6.23-rc8-mm2) Smack: Simplified Mandatory Access Control Kernel
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, casey@schaufler-ca.com
Cc: Al Viro <viro@ftp.linux.org.uk>, torvalds@osdl.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@osdl.org, paul.moore@hp.com
In-Reply-To: <20071003214045.72b6b9e0@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <384003.93417.qm@web36611.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > An embedded system that does not have user logins but that does
> > have applications that require separation, perhaps a moble communication
> > device with application download capability, is just one example
> > where the smack symlink implementation provides the required
> > function without requiring application support.
> 
> I don't see what is such a problem here. For your mobile example you'd
> give the application download side its own /tmp via mount.
> 
> Its actually better this is done in user space as its more flexible that
> way and can be tuned arbitarily to meet interesting or bizarre real world
> cases.

I admit to being impressed by the wide variety of mount options
currently available. In many cases this will be the best approach.
/tmp is a typical use for a smack symlink, but not the only one.


Casey Schaufler
casey@schaufler-ca.com
