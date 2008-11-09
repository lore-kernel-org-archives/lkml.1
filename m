Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbYKIROF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbYKIROF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 12:14:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbYKIRNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 12:13:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:55039 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208AbYKIRNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 12:13:52 -0500
Date: Sun, 9 Nov 2008 09:14:27 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Julia Lawall <julia@diku.dk>
Cc: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/8] drivers/media: use ARRAY_SIZE
Message-ID: <20081109091427.1d6bdfcd@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0811091754410.32509@ask.diku.dk>
References: <Pine.LNX.4.64.0811091754410.32509@ask.diku.dk>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Nov 2008 17:55:03 +0100 (CET)
Julia Lawall <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> ARRAY_SIZE is more concise to use when the size of an array is
> divided by the size of its type or the size of its first element.

Hi,
looking at your patch, I don't think I agree it's just blindly the
right thing to do.

> -	*count = sizeof(RegAddr) / sizeof(u8);
> +	*count = ARRAY_SIZE(RegAddr);

really. ARRAY_SIZE doesn't appear to be an improvement here..


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
