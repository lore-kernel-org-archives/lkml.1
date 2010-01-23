Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995Ab0AWX2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab0AWX2O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 18:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850Ab0AWX2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 18:28:13 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:65226 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab0AWX2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 18:28:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=BKmB175jN5wJEuLoohRdTQR0CLDo7dUz4uPZ0dbZaglNtpJVrkiKV+5vHOqx8LTWxt
         AL+Bs0S85XBxUNNKtR21o8EeVCxJxlpE2dZW8kFlwjN0HnAXmnXe2WLtri70WDGCvDjt
         ehC48I4rdxSwYRsemzN67m6qZCpxTUz5UcSRg=
Date: Sun, 24 Jan 2010 01:28:13 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Antonino Daplas <adaplas@pol.net>,
       linux-fbdev-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/29] move acornfb's probe function to .devinit.text
Message-ID: <20100123232813.GB4146@x200>
References: <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1264278937-19675-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1264278937-19675-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 23, 2010 at 09:35:09PM +0100, Uwe Kleine-König wrote:
> -static int __init acornfb_probe(struct platform_device *dev)
> +static int __devinit acornfb_probe(struct platform_device *dev)

Even more, if this function is marked __devinit, some other functions
can very well be marked __devinit, can you do this?
