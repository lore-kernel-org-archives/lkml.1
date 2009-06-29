Return-Path: <linux-kernel-owner+w=401wt.eu-S1759949AbZF2QV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759949AbZF2QV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758701AbZF2QVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:21:21 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:63628 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbZF2QVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:21:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dpPSCpxLw84Pr+I15wtSp1KUFFRUwvFWBCoi+dpReiLZ2yEV0eZaCQc3Ed7tbJmLT5
         MeIKDb6b0jk0xVOE86//wZzApL4u6jlZ+19nnfZuQXv0HgU8OYf02xq/KsoKl1skAN5S
         USCV3Kc4zqxPHa5JwB1qRieZwPmUxymo/J5Fo=
MIME-Version: 1.0
In-Reply-To: <4A48E307.2010208@numericable.fr>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
	 <5Hhc7UkUKEO.A.RvE.BjASKB@chimera> <4A489775.6020102@numericable.fr>
	 <20090629.033730.193709457.davem@davemloft.net>
	 <4A48E307.2010208@numericable.fr>
Date: Tue, 30 Jun 2009 00:21:23 +0800
Message-ID: <b6a2187b0906290921w15afd443qccb943ccfd48688b@mail.gmail.com>
Subject: Re: [Bug #13663] suspend to ram regression (IDE related)
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Etienne Basset <etienne.basset@numericable.fr>
Cc: David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       bzolnier@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 11:51 PM, Etienne
Basset<etienne.basset@numericable.fr> wrote:
> i ran a new bisection to identify the commit that cause pain after -rc1
> commit a1317f714af7aed60ddc182d0122477cbe36ee9b
> To have STR/resume work with current git, I have to :
> 1) apply Bart's patch
> 2) revert this commit : a1317f714af7aed60ddc182d0122477cbe36ee9b

I just tried, and it "seems" to work. Will try a few more cycles.

Thanks,
Jeff.
