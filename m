Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400Ab0AZXwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0AZXwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789Ab0AZXv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:51:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:35903 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868Ab0AZXv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:51:56 -0500
Message-ID: <4B5F813D.9090003@kernel.org>
Date: Wed, 27 Jan 2010 08:56:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jeff Garzik <jgarzik@redhat.com>
Subject: Re: [72/98] ata_piix: enable 32bit PIO on SATA piix
References: <20100126233930.322296166@mini.kroah.org>
In-Reply-To: <20100126233930.322296166@mini.kroah.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Jan 2010 23:50:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2010 08:34 AM, Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Tejun Heo <tj@kernel.org>
> 
> commit 0b67c7439fe2a5d76602de36854c88e2beab00b0 upstream.
> 
> Commit 871af1210f13966ab911ed2166e4ab2ce775b99d enabled 32bit PIO for
> PATA piix but didn't for SATA.  There's no reason not to use 32bit PIO
> on SATA piix.  Enable it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Umm... I don't really think this would be necessary for -stable.  It
probably won't break anything but at the same time this doesn't really
fix any critical problem.

Thanks.

-- 
tejun
