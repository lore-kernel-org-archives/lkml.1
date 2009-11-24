Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbZKXIAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbZKXIAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 03:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758025AbZKXIAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 03:00:18 -0500
Received: from mail-ew0-f215.google.com ([209.85.219.215]:36234 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758006AbZKXIAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 03:00:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=DRnOSGRuyC/ONGPRKIj9963VcT9mZLAsmZu8cuWNnhPtdmL97kjhntBRJUHZje3Dmo
         psy3VWkoar0oxXLZMXx6zPSl74P/OLojdV4LPRb/+BV09nRoAQgcoFU5EhA/R74y1mOr
         SROEvfm6Ly8abpLCSe7LJqQ3CH0HkwgBNHvRI=
Date: Tue, 24 Nov 2009 10:00:06 +0200
From: Dan Carpenter <error27@gmail.com>
To: Ang Way Chuang <wcang79@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dvb-core: Fix ULE decapsulation bug when less than 4
	bytes of ULE SNDU is packed into the remaining bytes of a MPEG2-TS
	frame
Message-ID: <20091124080006.GB14488@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Ang Way Chuang <wcang79@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <51d384e10911230137q7553b8c4x5ba3aca3e8edbc77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51d384e10911230137q7553b8c4x5ba3aca3e8edbc77@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 05:37:57PM +0800, Ang Way Chuang wrote:
> --- a/drivers/media/dvb/dvb-core/dvb_net.c
> +++ b/drivers/media/dvb/dvb-core/dvb_net.c
> @@ -458,8 +458,9 @@ static void dvb_net_ule( struct net_device *dev,
> const u8 *buf, size_t buf_len )

Your email client line broke the line starting with @@ into 2 lines so
the patch doesn't apply.

Could you resend the patch without line wrapping?

regards,
dan carpenter

