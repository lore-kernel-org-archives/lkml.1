Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbXIETUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbXIETUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 15:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbXIETT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 15:19:58 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:33700 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661AbXIETT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 15:19:57 -0400
Subject: Re: [PATCH 0/3] build system: section garbage collection for
	vmlinux
From: Daniel Walker <dwalker@mvista.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: sam@ravnborg.org, kai@germaschewski.name, linux-kernel@vger.kernel.org
In-Reply-To: <200709052014.12653.vda.linux@googlemail.com>
References: <200709051443.21522.vda.linux@googlemail.com>
	 <200709051937.04014.vda.linux@googlemail.com>
	 <1189017519.4442.24.camel@imap.mvista.com>
	 <200709052014.12653.vda.linux@googlemail.com>
Content-Type: text/plain
Date: Wed, 05 Sep 2007 12:07:15 -0700
Message-Id: <1189019235.4442.27.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-05 at 20:14 +0100, Denys Vlasenko wrote:
> On Wednesday 05 September 2007 19:38, Daniel Walker wrote:
> > > > You version doesn't work with CONFIG_MODULES right?
> > > 
> > > It works with CONFIG_MODULES.
> > 
> > Really? Take a look at this version,
> > 
> > http://lkml.org/lkml/2006/6/4/169
> > 
> > Marcello had to implement a two pass build to add back symbol used in
> > modules which got removed from the main kernel.. You don't appear to do
> > that. Marcelo also claims better size reduction than you.
> 
> This will discard EXPORT_SYMBOLs potentially used by
> out-of-tree modules.

Right , so it doesn't work with modules..

Daniel

