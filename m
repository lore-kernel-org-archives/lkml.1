Return-Path: <linux-kernel-owner+w=401wt.eu-S968567AbXEIGQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968567AbXEIGQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 02:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934666AbXEIGQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 02:16:32 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:52874 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934099AbXEIGQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 02:16:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=e+cCY8rlTDrCKJKGcUxfUahH7aNfNA13KGRsTeiV4IyBhgPV7jQ/26mmmsiObYegj/Z9kAHgTdP3+0NtShLOki5ZfqpUpEusP61kox9drTVERqAAjM8w96Wg7vkqcwMIW2wiwoqxiu+3f+b4S3DC20/WBHhBXe/WbH1UzROkd8g=
Subject: Re: Please revert 464bdd33e9baad9806c7adbd8dfc37081a55f27e
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <46416327.3080007@zytor.com>
References: <46413851.6070505@zytor.com> <1178690193.4747.16.camel@daplas>
	 <46416327.3080007@zytor.com>
Content-Type: text/plain
Date: Wed, 09 May 2007 14:16:14 +0800
Message-Id: <1178691374.4747.23.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 22:59 -0700, H. Peter Anvin wrote:
> Antonino A. Daplas wrote:
> > On Tue, 2007-05-08 at 19:56 -0700, H. Peter Anvin wrote:
> >> Checkin 464bdd33e9baad9806c7adbd8dfc37081a55f27e "fbdev: ignore VESA
> >> modes if framebuffer is disabled" is just plain wrong on any system
> >> which has support for extended text modes in its VESA BIOS.
> >>
> >> Antonio is incorrectly assuming this branchout is used only to set VESA
> >> graphics modes, but it's to set any VESA mode, be it text or graphics.
> >>
> > 
> > Okay.
> > 
> 
> I did, however, take a cue from this and the setup rewrite now makes the
> VESA graphics mode unselectable if CONFIG_FB is off.
> 

Ah, okay, thanks.

Tony


