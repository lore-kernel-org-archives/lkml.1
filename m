Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbYDMQXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbYDMQXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 12:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbYDMQXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 12:23:46 -0400
Received: from web36606.mail.mud.yahoo.com ([209.191.85.23]:43188 "HELO
	web36606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754792AbYDMQXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 12:23:45 -0400
X-YMail-OSG: qoagXH4VM1lv5pcNALgKs8Myu4YL3Vs_MEZ6sygMnPrWJ.iTAPFn54pkRnln2ix9MiOryRxgbA--
X-RocketYMMF: rancidfat
Date: Sun, 13 Apr 2008 09:23:44 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: Implementing a Linux Security Module
To: "d.capitella@tin.it" <d.capitella@tin.it>, linux-kernel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <11947e44e7e.d.capitella@tin.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <947311.34222.qm@web36606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "d.capitella@tin.it" <d.capitella@tin.it> wrote:

> Hi there! I'm studying the Linux Security Module Framework, and I'm
> experiencing some issues while trying to register the modules I create.
> 
> I created a basic test module that just registers itself as a lsm. I
> tried to load it on many distros, Ubuntu, Fedora, RedHat but it is not
> allowed to register. 
> 
> May this be due to other LSMs that doesn't 
> support stacking and that are
> already loaded on those distros? If 
> that's the problem, can't we just
> create a security module that does 
> nothing but managing the stacking of
> other security modules?

Yes, that is an option.

There was work on a stacking module early on, but the
lack of available modules and some of the stickier interaction
issues lead to it being set aside.

It certainly makes sense to stack a time-clock access
module and a physical location module. It would not
make sense to stack SELinux and ... well, anything.

What you need to do in the current environment is build your
own kernel, not just the module. It takes more time, disk,
and cpu, but that's about it.


Casey Schaufler
casey@schaufler-ca.com
