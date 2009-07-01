Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbZGAObb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbZGAObb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZGAObX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:31:23 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:63804 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbZGAObW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:31:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xqYopawGWOYwHB6g8sJwcJF6Q0+OER8bhT7yiNFOqd/mYoYgTeTFz6vHcthCnNAM0W
         vl1kjrzoFzCWw+ydlPRkxC3xCXIZi9iCdqoblEAx4ODBgUQhi9bYS1GVoAXGVp5kBMuq
         cUXRpqeH2Fn0OcKka0pm3iasVriyO0C54vH7I=
MIME-Version: 1.0
In-Reply-To: <b6a2187b0906290921w15afd443qccb943ccfd48688b@mail.gmail.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
	 <5Hhc7UkUKEO.A.RvE.BjASKB@chimera> <4A489775.6020102@numericable.fr>
	 <20090629.033730.193709457.davem@davemloft.net>
	 <4A48E307.2010208@numericable.fr>
	 <b6a2187b0906290921w15afd443qccb943ccfd48688b@mail.gmail.com>
Date: Wed, 1 Jul 2009 22:31:24 +0800
Message-ID: <b6a2187b0907010731k510150b5u1c7fce8cbed7c33b@mail.gmail.com>
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

On Tue, Jun 30, 2009 at 12:21 AM, Jeff Chua<jeff.chua.linux@gmail.com> wrote:

> I just tried, and it "seems" to work. Will try a few more cycles.

STD/STR survived quite a few cycles now. Patch seems to be doing the
right thing.

On Mon, Jun 29, 2009 at 11:51 PM, Etienne
Basset<etienne.basset@numericable.fr> wrote:

> To have STR/resume work with current git, I have to :

> 1) apply Bart's patch

This is not yet in Linus's tree. And much needed to really fix the problem.

> 2) revert this commit : a1317f714af7aed60ddc182d0122477cbe36ee9b

This is already in Linus's tree.


Thanks,
Jeff.
