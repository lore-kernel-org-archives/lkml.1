Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYCCRmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYCCRmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbYCCRi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:38:59 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:50814 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758254AbYCCRi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:38:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LyI9dLOLC9TTkcnKDwiVSmx5iBuSz7eGGUa2ORn/YMltK82Or49pGF2E2wX3VAcrUkRU8AryumW5Ur5mVBgBDqobgDZL9p8pdlywEDM0xAIsdowCAaIweUrnx4l/zQ5Sv23vjVrHvNkVPeorBOhwMoS+pKwjIsB3CLvtq+RfMIg=
Message-ID: <5d6222a80803030938k329acadas4d4b4e439cc4bbef@mail.gmail.com>
Date: Mon, 3 Mar 2008 14:38:56 -0300
From: "Glauber Costa" <glommer@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH 0/52] First attempt at smp integration
Cc: "Glauber Costa" <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de
In-Reply-To: <p737igj7mcd.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
	 <p737igj7mcd.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 2:23 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Glauber Costa <gcosta@redhat.com> writes:
>  >
>  > Comments are welcome.
>
>  The main difference between i386 and x86-64 smp boot up (among a lot
>  of quirks and workarounds in i386 that x86-64 doesn't have/need and
>  some trivialities) is that x86-64 follows the standard hotplug state
>  machine and i386 doesn't.
>
>  I would suggest that if you want to unify you convert i386 over to the new
>  state machine first because that is the key difference. Everything else
>  after that is relatively simple. You can probably pattern that after
>  the original changeset who did this for x86-64.
>
>  The reason I never attempted this myself is that i was too worried about
>  regressions on old machines for i386 (this code is partly very fragile)
>  You'll likely encounter that problem. Just make sure to keep a stable
>  email address for some years to handle the fallout.

Thanks Andi, all very helpful.
I'll try to handle the problems in my configuration, but I'm too very
sure they'll appear, and other people testing it will surely add up.

As for the e-mail address, I can list my personal address in the top
of the file, or make sure red hat won't fire me. Maybe I can do both.

-- 
Glauber  Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
