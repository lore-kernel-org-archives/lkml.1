Return-Path: <linux-kernel-owner+w=401wt.eu-S932166AbZJNHkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbZJNHkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755677AbZJNHkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:40:10 -0400
Received: from mail-qy0-f186.google.com ([209.85.221.186]:50059 "EHLO
	mail-qy0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654AbZJNHkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:40:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=trKDwcjtX5r8g+KvveiPxvVl4ocqITf2K4+5pK5QuVHwU0UL0SjEFw6GJ4zGwA6ql7
         RIoL2WNOsY481rwbtfxRSElPXCqJJeNoNeLHZikhBDpsPYRHdZpICOqVgkYfkeLyLdhR
         PvEcqD9If7txhH2EYWt4MO4qypkA3RTkb88So=
Date: Wed, 14 Oct 2009 00:39:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Kosina <jkosina@suse.cz>, rjw@sisk.pl, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.30 leaking keys on console switch
Message-ID: <20091014073927.GB5318@core.coreip.homeip.net>
References: <87eiss7uhb.fsf@basil.nowhere.org> <alpine.LNX.2.00.0907071048210.4994@wotan.suse.de> <20090708065325.GE3309@dtor-d630.eng.vmware.com> <alpine.LNX.2.00.0907081317000.27327@wotan.suse.de> <20091014045851.GA32413@core.coreip.homeip.net> <20091014071950.GF23248@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014071950.GF23248@one.firstfloor.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 09:19:50AM +0200, Andi Kleen wrote:
> > Btw, what kind of keyboard is this? I was playing today but I could not
> > get my USB keyboards to report release of more than 1 key per report....
> 
> The log was with a PS/2<->USB adapter, with a PS/2 keyboard connected
> to a USB port through it.
> 

Hmm, I don't think I have one of those... It is curious beast - we have
software autorepeat for HID but PS/2 keyboards do autorepeat
themselves... What will combination do?

-- 
Dmitry
