Return-Path: <linux-kernel-owner+w=401wt.eu-S1752087AbZDMVEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbZDMVEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZDMVEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:04:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41529 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbZDMVEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:04:33 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] add self-tests for rfc4309(ccm(aes))
Date: Mon, 13 Apr 2009 17:03:48 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.29.1-54.fc11.x86_64; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert.xu@redhat.com>
References: <200904091434.59639.jarod@redhat.com> <200904091516.57048.jarod@redhat.com> <20090410023108.GA7933@localhost.localdomain>
In-Reply-To: <20090410023108.GA7933@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904131703.50196.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 April 2009 22:31:08 Neil Horman wrote:
> On Thu, Apr 09, 2009 at 03:16:53PM -0400, Jarod Wilson wrote:
> > On Thursday 09 April 2009 14:52:04 Neil Horman wrote:
> > > On Thu, Apr 09, 2009 at 02:34:59PM -0400, Jarod Wilson wrote:
> > > > Patch is against current cryptodev-2.6 tree, successfully tested via
> > > > 'modprobe tcrypt type=45'. The number of test vectors might be a bit
> > > > excessive, but I tried to hit a wide range of combinations of varying
> > > > key sizes, associate data lengths, input lengths and pass/fail.
> > > > 
> > > > Signed-off-by: Jarod Wilson <jarod@redhat.com>

Ugh. I clearly missed *something* when testing, there's no way the patch
I sent actually fully passed. I have things working for real now though
locally, including a back-port to a certain 2.6.18-based kernel. :)

Updated patch or patches forthcoming... (probably tomorrow)

-- 
Jarod Wilson
jarod@redhat.com
