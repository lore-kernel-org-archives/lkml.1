Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbZI2TCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbZI2TCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 15:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbZI2TCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 15:02:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:36043 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbZI2TCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 15:02:50 -0400
Date: Tue, 29 Sep 2009 21:02:07 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, mingo@elte.hu,
       torvalds@linux-foundation.org, Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-api@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [RFC][v7][PATCH 8/9]: Define clone2() syscall
Message-ID: <20090929210207.247b94df@infradead.org>
In-Reply-To: <4AC255A4.4030002@zytor.com>
References: <20090924165548.GA16586@us.ibm.com>
	<20090924170308.GH16989@us.ibm.com>
	<200909242343.59903.arnd@arndb.de>
	<20090925082346.GB4436@localdomain>
	<20090925105632.GG12824@hawkmoon.kerlabs.com>
	<20090929180537.GD4625@us.ibm.com>
	<20090929184023.532DF34@magilla.sf.frob.com>
	<4AC255A4.4030002@zytor.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009 11:44:52 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 09/29/2009 11:40 AM, Roland McGrath wrote:
> > Why add a new syscall at all instead of just using a new CLONE_*
> > flag to indicate that the argument layout is different?
> 
> What an absolutely atrociously bad idea.
> 
> We already have a syscall layer which is painful to thunk in places,
> and this would make it much worse.
> 

syscalls are cheap as well.
cheaper than decades of dealing with such multiplexer mess ;/


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
