Return-Path: <linux-kernel-owner+w=401wt.eu-S968791AbXILOQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968791AbXILOQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 10:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968525AbXILOQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 10:16:07 -0400
Received: from hyrule.inforealm.org ([62.58.71.23]:46329 "EHLO
	hyrule.inforealm.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966534AbXILOQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 10:16:06 -0400
Date: Wed, 12 Sep 2007 16:16:05 +0200
From: Stef Epardaud <stef@epardaud.net>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-kernel@vger.kernel.org
Subject: [Resolved: bad RAM] Filesystem silent crash with EXT3
Message-ID: <20070912141604.GB24461@inforealm.org>
References: <20070912120203.GA23510@inforealm.org> <m3hcm0dm6z.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3hcm0dm6z.fsf@maximus.localdomain>
User-Agent: Mutt/1.5.11+cvs20060403
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 03:53:40PM +0200, Krzysztof Halasa wrote:
> Filesystem clean = the "dirty" flag is not set. With journaling
> fs it basically means the kernel didn't found errors during
> operation.
> It doesn't mean there are no errors.

That's what I assumed, and that's why I forced fsck.

> > If not, what can I do to figure out what went wrong ?
> I'd check with memtest86. Silent fs corruption is usually caused
> by faulty hardware such as RAM.

I feel like a fool now. You're absolutely right, my RAM is corrupted.
Sorry for the trouble folks, I'm very happy to come to the conclusion I
can rely on EXT3. Now I have to start worrying about how to detect RAM
corruption before it screws up my data next time.

> A system crash or especially power failure shouldn't damage ext3fs.

That's what I assumed, and I'm glad to see it's still true.

Once again, sorry for the trouble.
-- 
Stéphane Epardaud
