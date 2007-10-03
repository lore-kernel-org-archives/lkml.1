Return-Path: <linux-kernel-owner+w=401wt.eu-S1757120AbXJCUVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120AbXJCUVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 16:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbXJCUVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 16:21:34 -0400
Received: from web36601.mail.mud.yahoo.com ([209.191.85.18]:44854 "HELO
	web36601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752694AbXJCUVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 16:21:33 -0400
X-YMail-OSG: yOY5RecVM1m5KN9Cv6RDZBGXNyCcDRGjtUdHpVXbESaH_Gci4D8b7WHtj8_aMxqdRaLAJ0405w--
X-RocketYMMF: rancidfat
Date: Wed, 3 Oct 2007 13:21:32 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 4 (2.6.23-rc8-mm2) Smack: Simplified Mandatory Access Control Kernel
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@ftp.linux.org.uk>
Cc: Casey Schaufler <casey@schaufler-ca.com>, torvalds@osdl.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@osdl.org, paul.moore@hp.com
In-Reply-To: <20071003191735.4d92c593@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <342112.80881.qm@web36601.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Absolute paths in that kind of thing are _wrong_.  You know where the
> things
> > are on your fs.  You don't know if anything else will be visible, let alone
> > whether it will be at the same place in all chroots or namespaces.  And no,
> > you _can't_ make sure that fs is visible only in one place.  No fs can or
> > has any business even trying.
> 
> What I don't understand here is why we need the hacks when we already
> support sufficient mount magic to give each login session its own
> private /tmp ?

An embedded system that does not have user logins but that does
have applications that require separation, perhaps a moble communication
device with application download capability, is just one example
where the smack symlink implementation provides the required
function without requiring application support.
 

Casey Schaufler
casey@schaufler-ca.com
