Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbYIYQJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbYIYQJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 12:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbYIYQJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 12:09:16 -0400
Received: from outbound-mail-13.bluehost.com ([69.89.18.113]:60142 "HELO
	outbound-mail-13.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752747AbYIYQJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 12:09:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=eOmC3dIxFhzECvRREegSh9mTouQl/ouVY4Q+ybUMgfe74OfKwHMfXnnVb6xp8yn0u49rWs5qmSJDNh7niJwFd4apZkxrk3GFbMFYw4WR4Hb0GnjCKGcreYbwdF5ysVNN;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Date: Thu, 25 Sep 2008 09:08:36 -0700
User-Agent: KMail/1.9.9
Cc: David Miller <davem@davemloft.net>, jeffrey.t.kirsher@intel.com,
       airlied@gmail.com, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com, Ingo Molnar <mingo@elte.hu>,
       jesse.brandeburg@intel.com, Karsten Keil <kkeil@suse.de>
References: <20080923.150722.141587696.davem@davemloft.net> <200809241726.58628.jbarnes@virtuousgeek.org> <alpine.LNX.1.10.0809250230000.4671@pegasus.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0809250230000.4671@pegasus.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809250908.37676.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 24, 2008 5:33 pm Jiri Kosina wrote:
> On Wed, 24 Sep 2008, Jesse Barnes wrote:
> > That said, adding a check to the x86 code would be a good thing to do;
> > I'll hack up a patch tomorrow unless someone beats me to it.
>
> The problem here is that what we desperately need first is a method to
> restore the original EEPROM contents after it gets corrupted (David Airlie
> has, sadly, apparently bricked his notebook while trying to do so).
> Without this, we can put a lot of debugging/protecting patches into the
> kernel, but we won't be able to succesfully verify anything, because
> testing wouldn't be possible.
>
> Added Jesse and Karsten to CC, as they are working on such a tool right
> now, as far as I know.

I should be able to test the mmap fix independently of the e1000 breakage at 
least... lemme try it out now...

-- 
Jesse Barnes, Intel Open Source Technology Center
