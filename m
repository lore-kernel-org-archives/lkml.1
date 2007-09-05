Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbXIETOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbXIETOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 15:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbXIETO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 15:14:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:64413 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbXIETOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 15:14:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=KUGMMuHfj/MyWz6Dc4RC9IJHj7TlUuuNGjyjbShd3e4JUS5mcTNsohcnILeDJzkvoeF3rMbd4uT264OIwj4vS4bFAVFsLlblbtVNrir6h2ptQi2o5+YMoLZYQSHuQMbwsKGB9Y+vyJmwHQS9y6nq5o/RtS5y+6AfgrgSCDrc9e8=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH 0/3] build system: section garbage collection for vmlinux
Date: Wed, 5 Sep 2007 20:14:12 +0100
User-Agent: KMail/1.9.1
Cc: sam@ravnborg.org, kai@germaschewski.name, linux-kernel@vger.kernel.org
References: <200709051443.21522.vda.linux@googlemail.com> <200709051937.04014.vda.linux@googlemail.com> <1189017519.4442.24.camel@imap.mvista.com>
In-Reply-To: <1189017519.4442.24.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709052014.12653.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 September 2007 19:38, Daniel Walker wrote:
> > > You version doesn't work with CONFIG_MODULES right?
> > 
> > It works with CONFIG_MODULES.
> 
> Really? Take a look at this version,
> 
> http://lkml.org/lkml/2006/6/4/169
> 
> Marcello had to implement a two pass build to add back symbol used in
> modules which got removed from the main kernel.. You don't appear to do
> that. Marcelo also claims better size reduction than you.

This will discard EXPORT_SYMBOLs potentially used by
out-of-tree modules.

I also saw ~10% size reductions, but then at run-time test modules
failed to load, they didn't find needed symbols.

OTOH if I know that I am not going to be using such modules,
then this can be done. Will require another CONFIG_xxx, though.
--
vda
