Return-Path: <linux-kernel-owner+w=401wt.eu-S1764937AbXGaP7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764937AbXGaP7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 11:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbXGaP7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 11:59:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48672 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbXGaP7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 11:59:45 -0400
Date: Tue, 31 Jul 2007 21:42:02 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andi Kleen <andi@firstfloor.org>
cc: Jesper Juhl <jesper.juhl@gmail.com>,
       2004 ruffneck <ruffneck2004@yandex.ru>, linux-kernel@vger.kernel.org,
       virtualization@osdl.org
Subject: Re: How to enable XEN in 2.6.23-rcS kernel?
In-Reply-To: <p731weor0ee.fsf@bingen.suse.de>
Message-ID: <alpine.LFD.0.999.0707312140220.28746@enigma.security.iitk.ac.in>
References: <39811185887611@webmail12.yandex.ru>
 <9a8748490707310652i27406292yf3e93ca78ef3bf32@mail.gmail.com>
 <p731weor0ee.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 31 Jul 2007, Andi Kleen wrote:

> "Jesper Juhl" <jesper.juhl@gmail.com> writes:
> 
> > [...]
> > Go to "Processor type and features" - then enable "Paravirtualization
> > support (EXPERIMENTAL)", you'll get a new option called "Enable
> > support for Xen hypervisor".
> 
> Perhaps it would be clearer to make CONFIG_PARAVIRT implicit.
> As in Xen/vmi/lguest being one level higher and selecting paravirt 
> implicitely. Unless someone has a good reason against that i'll
> do that.

Sounds good, just ensure you carry PARAVIRT's dependencies to those who
"select" it too, somehow, otherwise invalid .config's could result.


Satyam
