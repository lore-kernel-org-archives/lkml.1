Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbZFVSZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbZFVSZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 14:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbZFVSZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 14:25:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752644AbZFVSZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:25:44 -0400
Date: Mon, 22 Jun 2009 11:22:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: =?ISO-8859-15?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
cc: Dave Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
       Andrew Lutomirski <luto@mit.edu>, dri-devel@lists.sf.net,
       Jerome Glisse <jglisse@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm: previous pull req + 1.
In-Reply-To: <4A3F3E3A.2030202@shipmail.org>
Message-ID: <alpine.LFD.2.01.0906221121100.3240@localhost.localdomain>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie> <4A3DABE1.50309@mit.edu> <alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie> <alpine.LFD.2.01.0906210945170.3119@localhost.localdomain> <alpine.LFD.2.01.0906210948340.3119@localhost.localdomain>
 <cb0375e10906211150v7c54f355ga0066eccc128085@mail.gmail.com> <alpine.LFD.2.01.0906211223190.3119@localhost.localdomain> <alpine.DEB.2.00.0906212336200.20307@skynet.skynet.ie> <4A3F3E3A.2030202@shipmail.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 22 Jun 2009, Thomas Hellström wrote:
> 
> It would be very helpful if we could introduce an fbdev mutex that protects
> fbdev accesses to the kernel map and to the fbdev acceleration functions.

Not going to happen.

Why? 'printk'.

If you can't handle printk, then you're basically useless. And printk 
absolutely -has- to work in bad situations (the most important messages 
could happen in any context).

			Linus
