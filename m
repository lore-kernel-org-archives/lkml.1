Return-Path: <linux-kernel-owner+w=401wt.eu-S932086AbZAQTrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbZAQTrd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 14:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763908AbZAQTrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 14:47:23 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:39185 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759874AbZAQTrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 14:47:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sb6ikmI/3Xuvbwxmdp5hjv+s19yu2uGTU7Cr3smfshKtOlcVoqH+HTMGoQn+uiWLay
         NSwmJ40SHz2PJJBl2WPvCrh/mjyCSINnAESxXAmSvYZEtoyHexUoyzVZnTSb9sAKNQw7
         8HrRNwCSwR5zFThUPs+0jSTyf5E3ccgLFmhSc=
Date: Sat, 17 Jan 2009 21:41:16 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 1/1] relay: fix lock imbalance in relay_late_setup_files
Message-ID: <20090117194116.GA5558@localhost>
References: <1232190276-21200-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232190276-21200-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2009 at 12:04:36PM +0100, Jiri Slaby wrote:
> One fail path in relay_late_setup_files() omits
> mutex_unlock(&relay_channels_mutex);
> Add it.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> Cc: Jens Axboe <axboe@suse.de>

Oh, I missed that. Looks good to me.


	Thanks,
	Eduard

