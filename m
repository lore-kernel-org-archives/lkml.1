Return-Path: <linux-kernel-owner+w=401wt.eu-S1031259AbXDQVQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031259AbXDQVQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 17:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031254AbXDQVQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 17:16:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48797 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031228AbXDQVQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 17:16:56 -0400
Date: Tue, 17 Apr 2007 23:16:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Andi Kleen <andi@firstfloor.org>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: AppArmor FAQ
Message-ID: <20070417211653.GB11944@one.firstfloor.org>
References: <20070417181016.GA10903@one.firstfloor.org> <657751.18080.qm@web36614.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <657751.18080.qm@web36614.mail.mud.yahoo.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> For SELinux to be effective it has to have a complete policy definition.
> This would prevent the OpenOffice access (unless OpenOffice is in the
> modify_resolv_conf_t domain) above.

This would mean no fully functional root user anymore. My understanding 
is rather that at least in the Fedora default setup individual applications
are confined with targetted policy and root left alone because normal system 
administrators get very unhappy when root becomes powerless.

I was merely pointing out that in this setup path or namespace based access 
control are much easier to fit in than label based access because they normally 
don't require changing applications. John's original document also
listed some other advantages that I don't need to repeat.

In "i don't care if it looks like Unix anymore" security setups like
you're describing that's undoubtedly different and labels might indeed
work because you forbid just anybody changing them easily. If that makes
the users happy is a different question though. I suppose it will
keep security consultants employed at least @)

Arguably the preserving label issue is not unique to SELinux but 
also applies to ACLs and other possible uses of EAs, but then people normally 
don't need to set any ACLs on /etc/resolv.conf.

I personally don't like either too much. Path based access control
is somewhat hackish and ugly and slow in the current implementation, 
but I haven't seen an similarly easy to configure solution yet.

plan9 like limited namespaces for individual processes initially seem 
like a nice alternative, but in practice they're also too hard to use and 
suffer from many of the problems the EA label approach has.

But easy to use security is probably better than complicated security
because normal people will more likely use it.

-Andi

