Return-Path: <linux-kernel-owner+w=401wt.eu-S1762973AbXHKVFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762973AbXHKVFl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 17:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756661AbXHKVFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 17:05:34 -0400
Received: from styx.suse.cz ([82.119.242.94]:36987 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757244AbXHKVFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 17:05:32 -0400
Date: Sat, 11 Aug 2007 23:06:48 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Renato Golin <rengolin@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: joydev.c and saitek cyborg evo force
In-Reply-To: <d9b9d95f0708111038p48f18660me02d3e75280b37e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708112302250.11054@jikos.suse.cz>
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com> 
 <d9b9d95f0706120608g979b89oc79dbc277d19862b@mail.gmail.com> 
 <d120d5000706120613o7a328e59v3cba37f0ced88e77@mail.gmail.com> 
 <d9b9d95f0706120631l20e6f91duaa110e72a0e955a6@mail.gmail.com> 
 <Pine.LNX.4.64.0706121715480.10204@jikos.suse.cz> 
 <d9b9d95f0706141524p3686a41cn882d8f086e4f62cc@mail.gmail.com> 
 <Pine.LNX.4.64.0706201156410.23812@jikos.suse.cz> 
 <d9b9d95f0707201710g14d8a905s222c1209358f0196@mail.gmail.com> 
 <Pine.LNX.4.64.0708101643360.11054@jikos.suse.cz> 
 <Pine.LNX.4.64.0708101753410.11054@jikos.suse.cz>
 <d9b9d95f0708111038p48f18660me02d3e75280b37e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Aug 2007, Renato Golin wrote:

> fixes perfectly. But it probably breaks the output range and kills the 
> force-feedback.

Thanks for testing.

Force feedback functionality shouldn't be influenced in any means by this 
patch - FF implementation doesn't care about the values of the 
input_dev->abs{max,min,fuzz,flat}.

But it is questionable whether your joystick is fully compliant with PID 
protocol or it implements some sort of vendor-specific one.

> I couldn't find fftest for debian (the package with jstest doesn't
> have it) but I'll compile and run here to test.

Thanks.

-- 
Jiri Kosina
SUSE Labs
