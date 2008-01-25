Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbYAYT4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbYAYT4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 14:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbYAYT4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 14:56:08 -0500
Received: from gw.goop.org ([64.81.55.164]:36724 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499AbYAYT4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 14:56:05 -0500
Message-ID: <479A3ED3.6020808@goop.org>
Date: Fri, 25 Jan 2008 11:56:03 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches against 2.6.24
References: <20080125071127.GA4860@kroah.com> <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org> <20080125185213.GA23475@suse.de> <alpine.LFD.1.00.0801251108480.2979@hp.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801251108480.2979@hp.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> I'm too lazy to want to do my own initrd. I just use the prepackaged ones 
> and rely on the fact that my private kernel will refuse to load modules 
> that aren't meant for it anyway.
>   

initrds generally aren't prepackaged, but generated on install (at least 
with Fedora).  You can regenerate them with "mkinitrd -f 
/boot/initrd-2.6.24.img 2.6.24".  Also, I find that "make 
modules_install install" does it automatically from a kernel build.

    J
