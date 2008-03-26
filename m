Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbYCZDWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbYCZDWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 23:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYCZDWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 23:22:11 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:35699 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbYCZDWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 23:22:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bwbaeFJzlULFO0SpwgpBieWW7jfsdqkAb742SI2JGi8wxhC61Gx4/P2eyc8nNFteV5N+sVoYD2tkmqfFe0+znlU1gtYk7h7/qfBxwu944/AaAVQWHNiOta1sD12H+jqYE8QETSJ05HlgbUqyBThSBaN8N7jCAHUFPIr8546kxXI=
Message-ID: <5d6222a80803252022n208abd1bieda5cfc4920e2b0c@mail.gmail.com>
Date: Wed, 26 Mar 2008 00:22:07 -0300
From: "Glauber Costa" <glommer@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [RFC 8/8] x86_64: Support for new UV apic
Cc: "Andi Kleen" <andi@firstfloor.org>, "Jack Steiner" <steiner@sgi.com>,
       mingo@elte.hu, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <47E9B398.3080008@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080324182122.GA28327@sgi.com> <87abknhzhd.fsf@basil.nowhere.org>
	 <20080325175657.GA6262@sgi.com>
	 <20080325180616.GX2170@one.firstfloor.org> <47E9B398.3080008@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 11:23 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Andi Kleen wrote:
>  > No instead of having lots of if (xyz_system) do_xyz_special()
>  > go through smp_ops for the whole thing so that UV would just have a
>  > special smp_ops that has special implementions or wrappers.
>  >
>  > Oops I see smp_ops are currently only implemented
>  > for 32bit. Ok do it only once smp_ops exist on 64bit too.
>  >
>
>  I think glommer has patches to unify smp stuff, which should include
>  smp_ops.
>

They are already merged in ingo's tree.

I'm still about to post some last-minute issues, but the full smp_ops
support is there.
-- 
Glauber Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
