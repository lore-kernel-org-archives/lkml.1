Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbZIHWhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbZIHWhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbZIHWhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:37:24 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:63729 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbZIHWhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:37:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OhnGx/xqoKWWb68GJW0QhsVmkhxOnWt11TKPaFFAiHrne+gtYxq09YMiRcWLFJqgHb
         Rsx3y3v1zx4VXKIbRFy59XWFmAH3xcDMu+7KEMcNg07mxA/d9D1Ps4Ar5XFcUGynpdnN
         DaU0EvznFnE2lLH9VQfEZEaJu8JQvHefoo4F4=
Date: Wed, 9 Sep 2009 00:28:21 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Linus Torvalds <torvalds@osdl.org>, airlied@linux.ie,
       linux-kernel@vger.kernel.org
Subject: Re: Regression DRM/i915/KMS: VGA connector unusable after
	2.6.31-rc8-git1, DVI connector ok
Message-ID: <20090908222821.GA10175@Pilar.aei.mpg.de>
References: <4AA6D858.6040505@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA6D858.6040505@t-online.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed  9.Sep'09 at  0:19:04 +0200, Knut Petersen wrote:
> Hi everybody!
> 
> During the release cycle of the 2.6.31-rc* kernels KMS started to work
> on my computer.
> 
> Booting with a monitor attached to both the VAG and the DVI connectors,
> kernel 2.6.31-rc8-git1
> detects both monitors correctly and sets the native video mode.
> 
> Booting the same configuration with kernel 2.6.31-rc8-git2 ... -rc9-git1
> gives a different result:
> the DVI-attached monitor is still working perfectly, the VGA-attached
> monitor does not detect a
> valid video signal and switches off.

I had a similar problem between -rc8 and -rc9, and the patch here

http://marc.info/?l=linux-kernel&m=125239311508274&w=2

fixed it for me.
