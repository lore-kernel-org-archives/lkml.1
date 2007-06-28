Return-Path: <linux-kernel-owner+w=401wt.eu-S1763471AbXF1ASy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763471AbXF1ASy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 20:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757280AbXF1ASq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 20:18:46 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:41435 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbXF1ASp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 20:18:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Y9TOjN32xPhJSuUxpEdyGGgQyEJkY9W6DsHecLnB7svmcRkvD+obdWcEjfd0YG/QjIXwjruS0JLmgSp2MfTzDZHZdJDwVebKGBCE+88zQwAMHFg4VBInD6nBp2ngyBg4Sq+bj9JGUc4tXdHfy7u0d8+aH7rNWFAEQ1PptqurmI0=
Message-ID: <4682FE5C.5070004@gmail.com>
Date: Wed, 27 Jun 2007 19:18:36 -0500
From: Patrick Draper <pdraper@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <200706271825.17459.ahartmetz@gmail.com> <46829E82.6080804@gmail.com> <200706272110.50744.ahartmetz@gmail.com> <4682EEDD.4020501@gmail.com>
In-Reply-To: <4682EEDD.4020501@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> KDE has finally dropped aRts from KDE4 and, again, ALSA has been mixing 
> by default for some time now so we're talking history anyway. You want 
> mixing on your card? You got it.

I've been following this discussion with some interest, to learn more 
about ALSA. I've been creating startup scripts for all of my sound-using 
applications which look like this:

LD_PRELOAD=libaoss.so exec /usr/bin/alsaplayer "$*"

I found that without libaoss.so preloaded, I wasn't getting software 
mixing at all. I'm constantly running an MP3 player, and with that 
library I can get sound alerts from other apps too.

I don't understand exactly what you mean by ALSA mixing by default. I 
have the OSS Mixer API selected during kernel compiles. Is that what you 
are referring to?

Thanks,

Patrick
