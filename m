Return-Path: <linux-kernel-owner+w=401wt.eu-S1760978AbZB0XVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760978AbZB0XVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 18:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755974AbZB0XVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 18:21:00 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:38262 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753336AbZB0XU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 18:20:59 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Rd43r1PU+tkb+eXbBKy/gDfB8B4iF0P3pJmW7aqu7Bm3xZj4AjJErMgH0pmRlr1SIDkQ9mQiEncOE9xiuYQjaL2A+SxqfATv0k507LFQPBsvKBMwIa0BrBj3XMjixbLAo4u89ou6Ddz/Krtwzjj6A28Gqn+bD3BaDtaMDkQWohA=  ;
X-YMail-OSG: hx_bpuwVM1kZcWOXoW7sbcwuQH2oMGoZDjkJSPtf7xHVoQnXRrtFFuj5p0DKDBo5mcDjjfpMbHE887ASl42v_uRnhyBwvlJbahUP3HaUaFy0Bx2LvaI.B1eZACRTK.Lf86m3tSIVYZUjR22eBhvHNSBq
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] mfd: twl4030: add twl4030-pwrbutton as our child
Date: Fri, 27 Feb 2009 15:20:56 -0800
User-Agent: KMail/1.9.10
Cc: me@felipebalbi.com, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, felipe.balbi@nokia.com,
       sameo@openedhand.com
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200902271358.46863.david-b@pacbell.net> <20090227141212.a2bc4a01.akpm@linux-foundation.org>
In-Reply-To: <20090227141212.a2bc4a01.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902271520.56696.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 February 2009, Andrew Morton wrote:
> > > 
> > > What has gone wrong here?
> > 
> > Not much I can see.  It's registering a platform_device,
> > but only if it could be used on this system.
> 
> Again, that all gets fixed if this is done the right way around.  Run
> your probe function.  If the hardware is there, register with the core
> and all the nodes appear.  If the hardware is not present: bale.

Right.  If there's no button hooked up to its "power button"
signal, don't register that "twl4030-pwrbutton" node.


> The design of the whole subsystem appears to be upside down :(

You seem to be missing something.  Is it only the lack of that
tweak Felipe sent?

