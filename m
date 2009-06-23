Return-Path: <linux-kernel-owner+w=401wt.eu-S1757805AbZFWAIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805AbZFWAIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 20:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZFWAHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 20:07:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:37669 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538AbZFWAHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 20:07:52 -0400
Subject: Re: [git pull] drm: previous pull req + 1.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@shipmail.org>
Cc: Dave Airlie <airlied@linux.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alex Deucher <alexdeucher@gmail.com>, Andrew Lutomirski <luto@mit.edu>,
       dri-devel@lists.sf.net, Jerome Glisse <jglisse@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4A3F3E3A.2030202@shipmail.org>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
	 <4A3DABE1.50309@mit.edu>
	 <alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie>
	 <alpine.LFD.2.01.0906210945170.3119@localhost.localdomain>
	 <alpine.LFD.2.01.0906210948340.3119@localhost.localdomain>
	 <cb0375e10906211150v7c54f355ga0066eccc128085@mail.gmail.com>
	 <alpine.LFD.2.01.0906211223190.3119@localhost.localdomain>
	 <alpine.DEB.2.00.0906212336200.20307@skynet.skynet.ie>
	 <4A3F3E3A.2030202@shipmail.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Jun 2009 10:00:13 +1000
Message-Id: <1245715213.4017.13.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 10:18 +0200, Thomas Hellström wrote:

> It would be very helpful if we could introduce an fbdev mutex that 
> protects fbdev accesses to the kernel map and to the fbdev acceleration 
> functions.

As far as I can remember, all fbdev operations are done under the
console semaphore.

(I know I did fix a bunch of that crap ages ago).

Cheers,
Ben.

