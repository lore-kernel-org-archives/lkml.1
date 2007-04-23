Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbXDWIc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbXDWIc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 04:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbXDWIc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 04:32:28 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:45249
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753916AbXDWIc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 04:32:27 -0400
Date: Mon, 23 Apr 2007 10:35:30 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Christoph Hellwig <hch@infradead.org>, Kyle Moffett <mrmacman_g4@mac.com>,
       chas@cmf.nrl.navy.mil, ecd@atecom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use spinlock instead of binary mutex in idt77252 driver
Message-ID: <20070423083530.GF10339@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Kyle Moffett <mrmacman_g4@mac.com>, chas@cmf.nrl.navy.mil,
	ecd@atecom.com, linux-kernel@vger.kernel.org
References: <20070422213959.GP5013@traven> <45C4C5F0-4F09-416D-A237-82FC28DF1883@mac.com> <20070423081753.GA27664@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423081753.GA27664@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, Apr 23, 2007 at 09:17:53AM +0100 Christoph Hellwig ha dit:

> On Sun, Apr 22, 2007 at 07:50:36PM -0400, Kyle Moffett wrote:
> > On Apr 22, 2007, at 17:39:59, Matthias Kaehlcke wrote:
> > >use spinlock instead of binary mutex in idt77252 driver
> > 
> > I think you really meant: "Use mutex instead of binary semaphore in  
> > idt77252 driver", since this is a binary semaphore (not a mutex,  
> > which are always binary):
> 
> And the binary semaphore terminology i a little confusing. struct
> semaphore is a full counting semaphore that is only used as a binary
> semaphore if we want to speak in CS terms.  Than everyone else just
> caled them semaphore before these patches started to show up :)

i'll take your suggestion into account for future patches. my
intention behind the usage of the term binary semaphore was to be more
precise, but i agree that it can be confusing

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

    I am incapable of conceiving infinity, and yet I do not accept finity
                          (Simone de Beauvoir)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
