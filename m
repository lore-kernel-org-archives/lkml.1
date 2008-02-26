Return-Path: <linux-kernel-owner+w=401wt.eu-S1765537AbYBZUvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765537AbYBZUvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761876AbYBZUvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:51:40 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:44275 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbYBZUvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:51:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cNKm2Eepjlkp8FUl+mrk2LnQB6/eiQvbyJBXa1A3RgpCu6ne/Jmos1ZzylAEbf9r5qCYZYlOm0wCuB4UVfb8oGXLNAYGE87+mUAUdbydCn9gspzJdewFcUKjl+TJcqRnPZJ+vFbjCEqaFz+Q73nBPAKJOLvAMf/unLyNPA0MCkc=
Subject: Re: [PATCH] fbcon: replace mono_col macro with static inline
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Antonino Daplas <adaplas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.64.0802260917410.5158@anakin>
References: <1203963237.5582.4.camel@brick>
	 <Pine.LNX.4.64.0802260917410.5158@anakin>
Content-Type: text/plain
Date: Tue, 26 Feb 2008 12:51:14 -0800
Message-Id: <1204059074.5582.35.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-26 at 09:18 +0100, Geert Uytterhoeven wrote:
> On Mon, 25 Feb 2008, Harvey Harrison wrote:
> > +static inline int mono_col(struct fb_info *info)
>                               ^^^^^^^^^^^^^^^^^^^^
> const struct fb_info *info?
> 

I suppose, but seeing as it's an inline, does it really matter?

Harvey

