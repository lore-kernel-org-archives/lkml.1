Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651Ab0AGEat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab0AGEat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 23:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756497Ab0AGEar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 23:30:47 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:49609 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab0AGEaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 23:30:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OyvINAdhngodfuivUlzH2snYm/A68kdp7+pWUHPzynVShUdW0sPi3qQ1eyRilzY9w8
         qwm72qoffplB6Ol/0B+lKmSnToNr8UQYIZziBVwhile164WKYV0DAkiGuE+R5M5vWyZJ
         0Cs8FpJzk9trpmQrs+tjDJgqz8uEsqJZYT6rk=
Date: Wed, 6 Jan 2010 20:30:40 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the suspend tree with the input tree
Message-ID: <20100107043040.GB2314@core.coreip.homeip.net>
References: <20100107150723.b07d521b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100107150723.b07d521b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 03:07:23PM +1100, Stephen Rothwell wrote:
> Hi Rafael,
> 
> Today's linux-next merge of the suspend tree got a conflict in
> drivers/input/serio/serio.c between commits
> 386d8772980be01b94bd463ea1e745732d7eb502 ("Input: serio - use device core
> to create 'id' attribute group") and
> ddf1ffbd40c92ff1e58c45fa96d309788f7beb60 ("Input: serio - let device core
> tell us if device was registered") from the input tree and commit
> f543d6795ccfbd443a042e012a6aea15e4f4c87a ("PM: Allow serio input devices
> to suspend/resume asynchronously") from the suspend tree.
> 
> I fixed it up (see below) but am not sure it this is the correct fix.  I
> can carry this fix as necessary.

I think the fix is fine, however, do we still need to do async serio
suspend, now that we sped up resetting psmouse and atkbd? Rafael?

-- 
Dmitry
