Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbXEYXiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbXEYXiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 19:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbXEYXir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 19:38:47 -0400
Received: from outbound-mail-36.bluehost.com ([69.89.20.190]:34374 "HELO
	outbound-mail-36.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752076AbXEYXir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 19:38:47 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/6] i386/x86_64: Allow disabling the putstr's from compressed boot wrapper
Date: Fri, 25 May 2007 16:38:37 -0700
User-Agent: KMail/1.9.6
Cc: Ben Collins <ben.collins@ubuntu.com>, Andi Kleen <andi@firstfloor.org>,
       Ben Collins <bcollins@ubuntu.com>, linux-kernel@vger.kernel.org
References: <98cd38b5.git.bcollins@ubuntu.com> <200705251623.55551.jbarnes@virtuousgeek.org> <46577112.7090106@zytor.com>
In-Reply-To: <46577112.7090106@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705251638.37489.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 25, 2007 4:28:18 H. Peter Anvin wrote:
> Jesse Barnes wrote:
> > But how often do you have to debug bootloader or compressed boot code? 
> > In fact, most debug output like this isn't very useful after some initial
> > debugging, so we usually take it out.  I'm not sure why this would be any
> > different...
>
> You're asking me this?
>
> I get to hear all the time about some new platform -- sometimes exotic,
> sometimes not -- breaking early boot.

Right, but you're special that way.  And moreover, you would know how to add 
such debug statements as needed.  But is this output something we really need 
enabled unconditionally for everyone?

I personally don't care that much, aside from the feeling that we have way too 
many printks in general...

Jesse
