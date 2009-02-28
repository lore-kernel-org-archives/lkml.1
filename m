Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbZB1Ibl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbZB1Ibl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 03:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZB1Ibe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 03:31:34 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:41579 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZB1Ibd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 03:31:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mZIbMJ/oUGvJDk0RwvcZYuddGMqP8Fh6vVeI/0GjOAeVXku4lwtHZ+EFZ828nuVOVY
         ohUSg/81+Tog/jfP9y/VCYSPKzApPJ6Wijs94bHF0M/H+76Rp2pg4snvnlASqdFaIkZj
         pwoqsyZ3N1/lHwyH0KfrOs7mQDe8Bz7U3iQ6Q=
Message-ID: <49A8F660.10604@gmail.com>
Date: Sat, 28 Feb 2009 09:31:28 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Eric Anholt <eric@anholt.net>
CC: Sitsofe Wheeler <sitsofe@yahoo.com>,
       Andrew Morton <akpm@linux-foundation.org>, airlied@linux.ie,
       keithp@keithp.com, dri-devel@lists.sourceforge.net,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: i915 X lockup
References: <49A7B253.906@gmail.com>	 <20090227023231.76e7c65f.akpm@linux-foundation.org>	 <20090227130440.GA24633@silver.sucs.org> <49A7EF52.8080105@gmail.com>	 <20090227231207.GA4687@silver.sucs.org> <1235780431.6992.14.camel@gaiman>
In-Reply-To: <1235780431.6992.14.camel@gaiman>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.2.2009 01:20, Eric Anholt wrote:
> KMS support is not a feature of the server but of your 2D driver.  You
> want 2.6.2, or things will be bad.

I have 2.5.0. After turning KMS off, problem seems to be solved.

Anyway, I would appreciate a version of the intel driver being in the 
Kconfig text, otherwise it looks like: don't use this on machines with 
installation from stone age. If one has latest stable release of a 
distro, he doesn't even think he doesn't have "new enough userspace".

For reference, the text is:
Choose this option if you want kernel modesetting enabled by default,
and you have a new enough userspace to support this. Running old
userspaces with this enabled will cause pain.
