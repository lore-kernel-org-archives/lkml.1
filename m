Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbYHMWH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbYHMWH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 18:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYHMWHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 18:07:16 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:53693 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbYHMWHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 18:07:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=b2J2txJ8LxVl3LHIQ+linO+76DPRSrltXYwFni0ymTKX8ehApyM5WB2s20pDXLXSt2
         IYBJ4WP5Kyc1XZ8tyvr8cwpjyVNrq3F3pIYi+owi3hrM6E2QoZcs3Z+/GFjfkgZBG4kW
         LIzmcUgwmQU2znu+j4X1JoZlGkOErYBILNYnk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] ide: remove CONFIG_BLK_DEV_IDE config option
Date: Thu, 14 Aug 2008 00:05:03 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200808132323.02369.bzolnier@gmail.com> <20080813213149.GC7071@cs181140183.pp.htv.fi>
In-Reply-To: <20080813213149.GC7071@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808140005.03603.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 August 2008, Adrian Bunk wrote:
> On Wed, Aug 13, 2008 at 11:23:02PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > Because hd.c was moved to drivers/block/ this config option
> > is superfluous now and may be removed.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  drivers/ide/Kconfig |   38 ++------------------------------------
> >  1 file changed, 2 insertions(+), 36 deletions(-)
> >...
> 
> /me wonders why your patch doesn't touch drivers/ide/Makefile

This is a very good question...

v2 interdiff:
