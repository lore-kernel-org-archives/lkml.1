Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbXIET7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbXIET7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 15:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbXIET7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 15:59:42 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:58666 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403AbXIET7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 15:59:42 -0400
Subject: Re: [PATCH 0/3] build system: section garbage collection for
	vmlinux
From: Daniel Walker <dwalker@mvista.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: sam@ravnborg.org, kai@germaschewski.name, linux-kernel@vger.kernel.org
In-Reply-To: <200709052049.30649.vda.linux@googlemail.com>
References: <200709051443.21522.vda.linux@googlemail.com>
	 <200709052014.12653.vda.linux@googlemail.com>
	 <1189019235.4442.27.camel@imap.mvista.com>
	 <200709052049.30649.vda.linux@googlemail.com>
Content-Type: text/plain
Date: Wed, 05 Sep 2007 12:46:59 -0700
Message-Id: <1189021619.4442.36.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-05 at 20:49 +0100, Denys Vlasenko wrote:

> What does "it" stand for in this sentence?

"it" is your patches, and I think we got to bottom of it .. "it" (i.e.
your patches) don't actually work with modules, which is what you
originally contended ..

> My patch was tested to work in my limited testing,
> but it is very conservative.
> 
> I can't talk for Marcelo, but his patch probably worked too,
> it just didn't guarantee that you can install kernel, and
> then compile and load external module. Wel, it will compile,
> but maybe will fail to load.

At least you should modify your Kconfig changes so that you don't allow
people to select your new option unless they have CONFIG_MODULES off..

Daniel

