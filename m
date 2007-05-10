Return-Path: <linux-kernel-owner+w=401wt.eu-S1757826AbXEJQpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826AbXEJQpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 12:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbXEJQpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 12:45:25 -0400
Received: from mail.exanet.com ([212.143.73.109]:35538 "EHLO mr.exanet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548AbXEJQpY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 12:45:24 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] NLM program ID for user space NLM server
Date: Thu, 10 May 2007 19:45:23 +0300
Message-ID: <A6FDE6B975803043804A49F12F49028E0F59D8@hawk.exanet-il.co.il>
In-Reply-To: <1178814431.6775.1.camel@heimdal.trondhjem.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] NLM program ID for user space NLM server
Thread-Index: AceTIBPar1Cjmpp2T2mb7YyTNdAV9wAAn6XQ
From: "Menny Hamburger" <menny@exanet.com>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Cc: "Neil Brown" <neilb@suse.de>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, but in our case we don't care. This is a dedicated server where we
don't see any usage for NLM client. We just want to prevent the kernel
from taking the port in case of some accidental NFS mount that ommitted
'nolock'. 

-----Original Message-----
From: Trond Myklebust [mailto:trond.myklebust@fys.uio.no] 
Sent: Thursday, May 10, 2007 6:27 PM
To: Menny Hamburger
Cc: Neil Brown; linux-kernel@vger.kernel.org
Subject: RE: [PATCH] NLM program ID for user space NLM server

On Thu, 2007-05-10 at 18:30 +0300, Menny Hamburger wrote:
> The idea in the change was to be able to override NLM_PROGRAM with 
> another definition (from our slightly customized build system), so 
> that the kernel never tries to register port 100021.

I repeat: The kernel _NEEDS_ to register RPC service 100021 on the
client so that rpc.statd can find it and notify it of server reboots.

Trond

