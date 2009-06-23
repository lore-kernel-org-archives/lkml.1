Return-Path: <linux-kernel-owner+w=401wt.eu-S1760718AbZFWPlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718AbZFWPlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759712AbZFWPk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:40:58 -0400
Received: from outbound-mail-302.bluehost.com ([67.222.53.9]:48888 "HELO
	outbound-mail-302.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759589AbZFWPk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:40:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WUs9DeRHgx6RTQOBf4qJWJ1I1oIX3PDPchemG5BrxtL2aRPiOsYgnn/yo2tunoqOMxuUgqKrVg1oA4E9MmYyoTOX1sTwuzsJl5PFw9AekI6hLwP0rxOqtCSrH8Fh0diA;
Date: Tue, 23 Jun 2009 08:40:44 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas =?UTF-8?B?SGVs?= =?UTF-8?B?bHN0csO2bQ==?= 
	<thomas@shipmail.org>,
       Dave Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
       Andrew Lutomirski <luto@mit.edu>, dri-devel@lists.sf.net,
       Jerome Glisse <jglisse@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm: previous pull req + 1.
Message-ID: <20090623084044.7906f2d0@jbarnes-g45>
In-Reply-To: <1245723975.4017.33.camel@pasglop>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
	<4A3DABE1.50309@mit.edu>
	<alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie>
	<alpine.LFD.2.01.0906210945170.3119@localhost.localdomain>
	<alpine.LFD.2.01.0906210948340.3119@localhost.localdomain>
	<cb0375e10906211150v7c54f355ga0066eccc128085@mail.gmail.com>
	<alpine.LFD.2.01.0906211223190.3119@localhost.localdomain>
	<alpine.DEB.2.00.0906212336200.20307@skynet.skynet.ie>
	<4A3F3E3A.2030202@shipmail.org>
	<1245715213.4017.13.camel@pasglop>
	<alpine.LFD.2.01.0906221721450.3240@localhost.localdomain>
	<1245719079.4017.25.camel@pasglop>
	<20090622181832.771dac03@jbarnes-g45>
	<1245722325.4017.29.camel@pasglop>
	<20090622190712.4c0ace71@jbarnes-g45>
	<1245723975.4017.33.camel@pasglop>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 12:26:15 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Mon, 2009-06-22 at 19:07 -0700, Jesse Barnes wrote:
> 
> > Yeah I don't think we should try to change the mode, unless we
> > really have to for whatever reason.  fbcon should generally be able
> > to paint to whatever we have up as long as we set it up properly.
> 
> Well... it may not. IE. The text consoles can be using a different
> mode than X, and so fbcon will be all setup for that ... (including
> how many lines/columns etc...).

Yeah, I was suggesting we change fbcon's view of the world at panic
time, rather than trying to change the mode.  It's a bit of surgery
though...

-- 
Jesse Barnes, Intel Open Source Technology Center
