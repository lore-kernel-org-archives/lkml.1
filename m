Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbXJXLu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbXJXLu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757386AbXJXLup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:50:45 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:35683 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757272AbXJXLuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:50:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Received:Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance;
	b=kHsvRGl5spPpa9uJgBTeBFLS6torP5JHOjezmNT0/JxKJpaobTq/T2Ntr+SS0VCMcaAjaUPj1A3h7uJNOtLIdbyOVe5lD8f++NVFbYvIr4RLn+7kR2PhCDJ+JNQRRvmo;
Message-ID: <55615.simon.1193226629@5ec7c279.invalid>
In-Reply-To: <20071023220649.5a76af82@laptopd505.fenrus.org>
References: <167451.96128.qm@web38607.mail.mud.yahoo.com>
    <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org>
    <200710192226.53233.agruen@suse.de>
    <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org>
    <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr>
    <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au>
    <20071022210956.31f7bbcf@laptopd505.fenrus.org>
    <20071023051642.GA3908@sequoia.sous-sol.org>
    <471E9260.6000704@goop.org>
    <20071023220649.5a76af82@laptopd505.fenrus.org>
Date: Wed, 24 Oct 2007 12:50:29 +0100
Subject: Linux Security *Module* Framework (Was: LSM conversion to static 
     interface
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Chris Wright" <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andreas Gruenbacher" <agruen@suse.de>,
       "Thomas Fricaccia" <thomas_fricacci@yahoo.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "James Morris" <jmorris@namei.org>,
       "Crispin Cowan" <crispin@crispincowan.com>,
       "Giacomo Catenazzi" <cate@debian.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I currently have an LSM that only handles permissions for socket_bind
and socket_listen, I load it and then "capability" as secondary on
boot - but now I can't because the LSM framework is now just the LS
framework.

Why can't this "static LSM" change be a Kconfig option?
(I don't want to have to maintain my own reverted copy of security/,
or compile this into the kernel because then I can't ever modify and
reload it without rebooting.)

-- 
Simon Arlott
