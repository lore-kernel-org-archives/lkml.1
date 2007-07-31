Return-Path: <linux-kernel-owner+w=401wt.eu-S1764034AbXGaPrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764034AbXGaPrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 11:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbXGaPq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 11:46:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825AbXGaPq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 11:46:56 -0400
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Cc: "2004 ruffneck" <ruffneck2004@yandex.ru>, linux-kernel@vger.kernel.org,
       virtualization@osdl.org
Subject: Re: How to enable XEN in 2.6.23-rcS kernel?
References: <39811185887611@webmail12.yandex.ru>
	<9a8748490707310652i27406292yf3e93ca78ef3bf32@mail.gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 31 Jul 2007 18:41:29 +0200
In-Reply-To: <9a8748490707310652i27406292yf3e93ca78ef3bf32@mail.gmail.com>
Message-ID: <p731weor0ee.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Jesper Juhl" <jesper.juhl@gmail.com> writes:

> On 31/07/07, 2004 ruffneck <ruffneck2004@yandex.ru> wrote:
> > Hello to everybody!
> >
> > I did read, that Lguest and Xen was merged to upstream and must be in 2.6.23-rc1 kernel, but I can't see it in "make menuconfig". So, what's the deal? Can anybody explain me, how to enable XEN support? Thanks.
> 
> Go to "Processor type and features" - then enable "Paravirtualization
> support (EXPERIMENTAL)", you'll get a new option called "Enable
> support for Xen hypervisor".

Perhaps it would be clearer to make CONFIG_PARAVIRT implicit.
As in Xen/vmi/lguest being one level higher and selecting paravirt 
implicitely. Unless someone has a good reason against that i'll
do that.

-Andi
