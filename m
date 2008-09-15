Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYIOGUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYIOGUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 02:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbYIOGUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 02:20:08 -0400
Received: from nocturne.unbit.it ([81.174.68.18]:35610 "EHLO smtp.unbit.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751683AbYIOGUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 02:20:07 -0400
Subject: Re: [PATCH] xen: Fix for xen guest with mem > 3.7G
From: Roberto De Ioris <roberto@unbit.it>
Reply-To: roberto@unbit.it
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, jeremy@xensource.com,
       linux-kernel@vger.kernel.org, Mirko Iannella <mirko@unbit.it>,
       Alex Nixon <alex.nixon@citrix.com>
In-Reply-To: <48CDFC10.8060906@goop.org>
References: <1221333418.6036.9.camel@sirius> <48CC2C12.4080302@goop.org>
	 <20080914132104.GB32106@elte.hu>  <48CD22CF.9030900@goop.org>
	 <1221428593.6036.15.camel@sirius>  <48CDFC10.8060906@goop.org>
Content-Type: text/plain
Organization: Unbit
Date: Mon, 15 Sep 2008 08:20:01 +0200
Message-Id: <1221459601.6036.18.camel@sirius>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-09-14 at 23:09 -0700, Jeremy Fitzhardinge wrote:
> Roberto De Ioris wrote:
> > In this way you pass a 64bit integer to the function, but max_pfn in
> > origin is still 32bit.
> >
> > max_pfn need to be 64bit to supporto more than 4GB
> >   
> 
> No, a 32-bit pfn (page frame number) is sufficient for 2^44 bytes of
> memory.  Does this patch work for you?
> 
>     J


Ops, you are right, pfn is not in bytes ;)

The patch works.

-- 
Roberto De Ioris
http://unbit.it
JID: roberto@jabber.unbit.it

