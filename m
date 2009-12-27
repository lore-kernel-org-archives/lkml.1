Return-Path: <linux-kernel-owner+w=401wt.eu-S1751672AbZL0KKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbZL0KKs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 05:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZL0KKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 05:10:47 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:57654 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbZL0KKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 05:10:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q1yq88RT5j+Y0nG7E+Hc/32OK4mLlaYwa1ZP5lI2Lt6D9/9Gd54KlOjP65TR3hoM6z
         diXis76XFXsH9so3ZRfuIsYZFQ2zHtYW5LJWBgrMm7ZadXmS1F4Lei+ukmr45ituq0tq
         nJsP2F4YUBHYoFSN0uUJJBWi+0Fm3U2Phe180=
Date: Sun, 27 Dec 2009 02:10:41 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Linux Input <linux-input@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFT] Input: speed up suspend/shutdown for PS/2 mice and
 keyboards
Message-ID: <20091227101041.GD14655@core.coreip.homeip.net>
References: <20091221070951.GA4170@core.coreip.homeip.net>
 <20091227002658.GB26593@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091227002658.GB26593@khazad-dum.debian.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 26, 2009 at 10:26:58PM -0200, Henrique de Moraes Holschuh wrote:
> Works on my ThinkPad T43 (KBC emulated by the embedded controller firmware),
> although I don't think it made much difference in speed.
> 

Thanks. The speedup should not be that noticeable (even worst hardware
usually manages to do full reset in 0.5 sec), still 0.5 sec here and 0.5
sec there may add up.

-- 
Dmitry
