Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbXJWJOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbXJWJOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 05:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbXJWJOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 05:14:07 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:47039 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbXJWJOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 05:14:06 -0400
Date: Tue, 23 Oct 2007 11:14:05 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Chris Wright <chrisw@sous-sol.org>
cc: Arjan van de Ven <arjan@infradead.org>, James Morris <jmorris@namei.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LSM conversion to static interface [revert patch]
In-Reply-To: <20071023091305.GI3660@sequoia.sous-sol.org>
Message-ID: <Pine.LNX.4.64.0710231113480.16684@fbirervta.pbzchgretzou.qr>
References: <167451.96128.qm@web38607.mail.mud.yahoo.com>
 <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org>
 <200710192226.53233.agruen@suse.de> <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org>
 <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr>
 <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au>
 <20071022210956.31f7bbcf@laptopd505.fenrus.org> <20071023051642.GA3908@sequoia.sous-sol.org>
 <Pine.LNX.4.64.0710231057020.16684@fbirervta.pbzchgretzou.qr>
 <20071023091305.GI3660@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 23 2007 02:13, Chris Wright wrote:
>* Jan Engelhardt (jengelh@computergmbh.de) wrote:
>> On Oct 22 2007 22:16, Chris Wright wrote:
>> >Yes, and I think we can still improve performance although I can't see
>> >anyway to help out the modular case, so I guess it will have to incur
>> >the hit that's always been there.  I think your Kconfig option is a
>> >decent compromise.
>> 
>> (Un)registering security modules is a one-time hit. You do not load
>> and unload modules on a per-minute basis outside debugging.
>
>I'm referring to the hit for indirect calls

Indeed, I just seen that. Not too nice :(
