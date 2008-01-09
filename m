Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbYAIJyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbYAIJyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 04:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbYAIJyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 04:54:16 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:38960 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbYAIJyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 04:54:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pfmGPyPYXHWTf8h8EKX7Nvn3dpsikDN4BsUD+ZymeBvat4mqHiMdUgVbsgwwAgoVSlrxGDUPatjMuOiOAsGkfEYiewy/F1tSiDM9XipGIZu+gMwoLiBDPh22QagJsJjSrRA6pr3pg/MWZWloapBhD0xIZRQvByyZQo/wtk90aJU=
Message-ID: <6e0cfd1d0801090154r75c9ca93v5361aea45fe41bb5@mail.gmail.com>
Date: Wed, 9 Jan 2008 10:54:11 +0100
From: "Martin Schwidefsky" <schwidefsky@googlemail.com>
To: "Theodore Tso" <tytso@mit.edu>, "Tuomo Valkonen" <tuomov@iki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
In-Reply-To: <20080108181525.GL27800@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
	 <p73odbwqmx2.fsf@bingen.suse.de>
	 <slrnfo7b3a.6m2.tuomov@jolt.modeemi.cs.tut.fi>
	 <20080108181525.GL27800@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 8, 2008 7:15 PM, Theodore Tso <tytso@mit.edu> wrote:
> That will fix the this issue.  The problem you are facing is that you
> have your hardware clock set to ticking localtime, instead of GMT.
> Windows ticks localtime, which is a mistake carried over from the
> 1970's and MS-DOS.  Ticking localtime has all sorts of problems, among
> which is if you reboot around the transition between Summer Time (or
> Daylight Savings Time, depending on your contry) and normal time, the
> OS has no idea whether the DST adjustment has been applied or not.

Actually you can force Windows to accept a hardware clock in UTC:
HKEY_LOCAL_MACHINE/SYSTEMCurrentControlSetControl/TimeZoneInformation/RealTimeIsUniversal

I'm using this on my dual-boot machine at home because I that stupid
Daylight Savings Time change twice a year really annoyed me. So far
the only downside I found is that you have to remember that the time
you enter in the BIOS has to be UTC.

-- 
blue skies,
  Martin
