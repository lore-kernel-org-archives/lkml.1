Return-Path: <linux-kernel-owner+w=401wt.eu-S1757752AbYEPNyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752AbYEPNyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 09:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137AbYEPNxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 09:53:52 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:50253 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493AbYEPNxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 09:53:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=WuHpBMUT6s4xZX6wrbA68ODW/T9DUfJ/zqRfn2rYAJ3FRUsrjphHn6cTTWgTDMTA9xxzamNcX57ZESmpnUZDlogyecuK8ZOG9/NGSBw01g9qKt68wSdAHswsJxVPi1s4702JapezxuVOaO5A9j1akCwxjskrj5OPaqiQDpjBFN4=
Date: Fri, 16 May 2008 09:53:47 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <greg@kroah.com>, jkosina@suse.cz, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: add appleir USB driver
Message-ID: <20080516095218.ZZRA012@mailhub.coreip.homeip.net>
References: <20080514221519.GA6575@kroah.com> <20080515132108.GA9327@dose.home.local> <20080515094212.ZZRA012@mailhub.coreip.homeip.net> <20080515174939.GA10881@dose.home.local> <20080515142845.ZZRA012@mailhub.coreip.homeip.net> <20080515205950.GA11794@dose.home.local> <20080516090351.ZZRA012@mailhub.coreip.homeip.net> <20080516133234.GA10193@thinkpad.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516133234.GA10193@thinkpad.home.local>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 03:32:34PM +0200, Tino Keitel wrote:
> On Fri, May 16, 2008 at 09:13:41 -0400, Dmitry Torokhov wrote:
> 
> [...]
> 
> > Does the learning remote have the same VID/PID as AppleIr? If not I am
> > not sure why you are btringing it here.
> 
> It has no VID/PID at all, as it is not connected to the computer. It
> just sends IR codes to the IR sensor in the Mac mini (the builtin USB
> device that the appleir driver is for). And as the learning remote has
> more than 6 keys, it can send more than 6 different codes. The Apple
> remote has only 6 keys, and only these keys are handled by the driver.
> 

OK, I see.. How many codes does the sensor support? We should simply
allow for the key table big enough and allow userpsace to
assign/modify keycodes.

-- 
Dmitry
