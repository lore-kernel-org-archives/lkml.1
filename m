Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbYC0OeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbYC0OeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 10:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757336AbYC0OeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 10:34:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:10395 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbYC0OeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 10:34:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BilHOz21507zOKVg8xuUxZT4/PfpiKjHvZCG3h/KhH0vzoAYPWHyP6YpR0bU5SJGCwe6Y+lUIJ71P+Dss+46v0RkCJk1SwTEy/XlGWuzCfmcVga8C1VoEDV6FXqP0ZeOWWlQDGg/KGRHCMIHPXzaBoWV3MGal5ZBITYqU2pR4+A=
Message-ID: <b6c5339f0803270734x6e3d0462v40508bf66a82ba2a@mail.gmail.com>
Date: Thu, 27 Mar 2008 10:34:07 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Sergey Vlasov" <vsu@altlinux.ru>
Subject: Re: [PATCH 6/7] omfs: add checksumming routines
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       harvey.harrison@gmail.com
In-Reply-To: <20080327164114.6c9fc82c.vsu@altlinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206578760-9050-6-git-send-email-me@bobcopeland.com>
	 <20080327164114.6c9fc82c.vsu@altlinux.ru>
X-Google-Sender-Auth: 8d1291eccbd48e36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 9:41 AM, Sergey Vlasov <vsu@altlinux.ru> wrote:
> On Wed, 26 Mar 2008 20:45:59 -0400 Bob Copeland wrote:
>  > +static u16 omfs_crc(u16 crc, unsigned char *buf, int count)
>
>  Is this the same as crc_itu_t() from lib/crc-itu-t.c (also duplicated
>  in fs/udf/crc.c)?

Ah, thanks, that is the one.  I'll update the patch.

-Bob
