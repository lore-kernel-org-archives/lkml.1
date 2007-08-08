Return-Path: <linux-kernel-owner+w=401wt.eu-S1763064AbXHHQBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763064AbXHHQBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760108AbXHHQAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:00:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59347 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758540AbXHHQAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:00:42 -0400
Date: Wed, 8 Aug 2007 18:00:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: =?iso-8859-1?Q?C=E9dric?= Augonnet <cedric.augonnet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Loic Prylli <loic@myri.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, brice@myri.com,
       cedric.augonnet@ens-lyon.org
Subject: Re: PAT support for i386 and x86_64
Message-ID: <20070808160039.GA16357@one.firstfloor.org>
References: <f56c1ba00708061903r29baea3dj6b57032be5820983@mail.gmail.com> <20070807083004.GB30085@one.firstfloor.org> <46B97E39.3020905@myri.com> <20070808101441.GA12861@one.firstfloor.org> <f56c1ba00708080842i1eaa00kef5071d9a1f01f04@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f56c1ba00708080842i1eaa00kef5071d9a1f01f04@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 11:42:17AM -0400, Cédric Augonnet wrote:
> changing this register is absolutely not the actual issue with PAT, but
> don't
> you think such a first step is needed to avoid conflicts since people _do_
> already set that register from their driver.

Which drivers do that? Ok, I know the ATI 3d driver does, but if that
crashes the users know who is to blame.

No, I don't think we should merge a potentially data corrupting "first
step.". Even first steps have to meet some standards.

> Of course there is no problem for that being dependant on a CONFIG_PAT.

I don't think a CONFIG_DATA_CORRUPTION is a good idea.

-Andi
