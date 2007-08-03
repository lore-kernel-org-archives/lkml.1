Return-Path: <linux-kernel-owner+w=401wt.eu-S1761738AbXHCMNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761738AbXHCMNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 08:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbXHCMN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 08:13:29 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:14146 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbXHCMN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 08:13:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Cgmo/NOOxQsgF2pCCFTY+OClpp8YzINVhbvGc4jeOrM1Pt7TJ0YS1Thzr9CQTEsaVpaUjPao4t9rg86zRklJLvw/nCmm6yPt4zFmWkd1QoTXj5SFL7quAAnAAGkmb7ClT7bMkVY2ezLlGqfPypUH+YnUeLZvzjtjzAI2Xg/16c8=
Message-ID: <64bb37e0708030513w7da84fbcia3cb3b90c75a0550@mail.gmail.com>
Date: Fri, 3 Aug 2007 14:13:26 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Ed L. Cashin" <ecashin@coraid.com>
Subject: Re: ATA over ethernet swapping and obfuscated code
Cc: "Pavel Machek" <pavel@ucw.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070731162140.GI3206@coraid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070731135831.GA4604@elf.ucw.cz>
	 <20070731150324.GE3206@coraid.com> <20070731152924.GM2087@elf.ucw.cz>
	 <20070731162140.GI3206@coraid.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/07, Ed L. Cashin <ecashin@coraid.com> wrote:
> It is easy to chat, though.  Maybe someday I will test and submit a
> patch that implements this mechanism, but I'm hoping that somebody
> beats me to it.  :)

There is already such a mechanism (planned).

swap over networked storage -v11
http://lwn.net/Articles/223057/

"... Also knowing it is headed towards the VM needs a little help, hence we
introduce the socket flag SOCK_VMIO to mark sockets with. ..."

But it seems it did not make it into -mm.

HTH

Torsten
