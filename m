Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbZIRTb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbZIRTb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757085AbZIRTbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:31:51 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:51196 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbZIRTbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:31:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=JiKUbuHC3Mo5699n4V6unUzt7d1hARaFhFZbosFhRKIvpyzoYHM51uVwR1jtScrQHn
         zRkEiEhNY9T1BMYwFXCeBQ8jfbQc+d6o6WCRIjt/OnUr2jnOYEOYJatw79wBRwa60Jsm
         M0OyJ5u0yZPDNIi86XZK29zFBemTg9XHMz9vI=
Date: Fri, 18 Sep 2009 15:25:55 -0400
From: Joseph Fannin <jfannin@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Problems booting 2.6.31 on Fedora 8
Message-ID: <20090918192555.GA4224@nineveh.rivenstone.net>
Mail-Followup-To: Ben Greear <greearb@candelatech.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <4AB3C9A8.4060700@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB3C9A8.4060700@candelatech.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 10:55:52AM -0700, Ben Greear wrote:
> I'm having troubles booting 2.6.31 on Fedora 8.  The same kernel
> boots fine on F11, but on F8, it cannot find the root logical volume.
>
> One thing I notice is that F11 uses root=/dev/mapper... and F8 uses
> root=/dev/VolGroup00/LogVol00 in grub.  It's not clear to me what
> the value of mapper should be...is there some way to figure this
> out from an older kernel (2.6.29) that boots fine?

Possibly /dev/mapper/VolGroup00-LogVol00 .

--
Joseph Fannin
jfannin@gmail.com

