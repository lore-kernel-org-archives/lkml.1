Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYAITr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYAITr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 14:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYAITrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 14:47:52 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:34018 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbYAITrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 14:47:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tFzv9KaJdV8LYFVoa1zaxFqSxN8uBZ985hvWmvLy1LqSKllcPEoqczDaK5EI15cGoxu6fwjk6PTUmuf29gL6zFJl5M7LH5DL5x/Fy9IrzCwFAQGWSa037Tsk7mBNoFN7iZizd8wA9GOyVmHVIozOcQ1rmudZ8G1lKdchYqTaXVE=
Message-ID: <6e0cfd1d0801091147v5a20ce6exe3558ad2cd90eba3@mail.gmail.com>
Date: Wed, 9 Jan 2008 20:47:48 +0100
From: "Martin Schwidefsky" <schwidefsky@googlemail.com>
To: "Theodore Tso" <tytso@mit.edu>,
       "Martin Schwidefsky" <schwidefsky@googlemail.com>,
       "Tuomo Valkonen" <tuomov@iki.fi>, linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
In-Reply-To: <6e0cfd1d0801090553r4187dfa2lb8cb6b848f06669f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
	 <p73odbwqmx2.fsf@bingen.suse.de>
	 <slrnfo7b3a.6m2.tuomov@jolt.modeemi.cs.tut.fi>
	 <20080108181525.GL27800@mit.edu>
	 <6e0cfd1d0801090154r75c9ca93v5361aea45fe41bb5@mail.gmail.com>
	 <20080109122556.GL21097@mit.edu>
	 <6e0cfd1d0801090553r4187dfa2lb8cb6b848f06669f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 9, 2008 2:53 PM, Martin Schwidefsky <schwidefsky@googlemail.com> wrote:
> On Jan 9, 2008 1:25 PM, Theodore Tso <tytso@mit.edu> wrote:
> > On Wed, Jan 09, 2008 at 10:54:11AM +0100, Martin Schwidefsky wrote:
> > > Actually you can force Windows to accept a hardware clock in UTC:
> > > HKEY_LOCAL_MACHINE/SYSTEMCurrentControlSetControl/TimeZoneInformation/RealTimeIsUniversal
> >
> > Oh, so cool!!!  Do you know off hand what version of Windows started
> > honoring that registry setting?
>
> I have a Windows XP next to Linux on my home box. So I can say from
> experience that Windows XP works. I have no idea if older versions had
> that registry entry as well.
>
> > And what do you set that registry value to?  Just a boolean "true"?
>
> I can check my dual-boot machine when I get home. I think it was just "1".

RealTimeIsUniversal is a REG_DWORD with content "1".

-- 
blue skies,
  Martin
