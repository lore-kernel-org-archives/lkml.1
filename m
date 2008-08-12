Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbYHLTIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbYHLTIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 15:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbYHLTH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 15:07:59 -0400
Received: from smtprelay10.ispgateway.de ([80.67.29.24]:56933 "EHLO
	smtprelay10.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbYHLTH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 15:07:58 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/2] CRED: Introduce credential access wrappers
Date: Tue, 12 Aug 2008 21:02:14 +0200
User-Agent: KMail/1.9.9
Cc: sfr@canb.auug.org.au, jmorris@namei.org, hch@infradead.org,
       davem@davemloft.net, sfrench@us.ibm.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
References: <20080812132840.5472.25856.stgit@warthog.procyon.org.uk> <20080812132850.5472.5131.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080812132850.5472.5131.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808122102.15794.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tuesday 12 August 2008, David Howells wrote:
> Wrappers are introduced into a new header (linux/cred.h) for UID/GID,
> EUID/EGID, SUID/SGID, FSUID/FSGID, cap_effective and current's subscribed
> user_struct.

Why macros? When introducing APIs using trivial inlines makes sure that 
the conversion is correct, type correct and side effect free for the callers.
Macros cannot ensure this without pain.

Please respin this patch with inlines. If that needs header changes,
your CRED subsytem might need that, too.


Best Regards

Ingo Oeser
