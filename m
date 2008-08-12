Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbYHLXFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbYHLXFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 19:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYHLXFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 19:05:06 -0400
Received: from smtprelay10.ispgateway.de ([80.67.29.24]:50804 "EHLO
	smtprelay10.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYHLXFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 19:05:05 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/2] CRED: Introduce credential access wrappers
Date: Wed, 13 Aug 2008 00:59:19 +0200
User-Agent: KMail/1.9.9
Cc: sfr@canb.auug.org.au, jmorris@namei.org, hch@infradead.org,
       davem@davemloft.net, sfrench@us.ibm.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
References: <200808122102.15794.ioe-lkml@rameria.de> <20080812132850.5472.5131.stgit@warthog.procyon.org.uk> <9503.1218572852@redhat.com>
In-Reply-To: <9503.1218572852@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808130059.21049.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tuesday 12 August 2008, David Howells wrote:
> Ingo Oeser <ioe-lkml@rameria.de> wrote:
> 
> > Why macros? When introducing APIs using trivial inlines makes sure that 
> > the conversion is correct, type correct and side effect free for the callers.
> > Macros cannot ensure this without pain.
> 
> But macros don't care that you can't access current at this point.

Ok, if that is the only reason, please mention this in the commit message.
That would be enough for me to not wonder about this issue.

But I wonder how you solve this issue if the amount of code behinde your wrappers
grows.

If you have to take them out of line, it would give me a good indication
of the costs involved in the later bodies of these now trivial wrappers,
if you do it right away. 

That way you'll find missing includes and whatnot while converting existing code
to the trivial wrappers.


Best Regards

Ingo Oeser
