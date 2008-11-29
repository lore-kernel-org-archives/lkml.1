Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbYK2ViU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbYK2ViU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 16:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYK2ViJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 16:38:09 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:43435 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbYK2ViI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 16:38:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VEbb4MCmbD5QCWorBHdlHPj5f7L3UcfvjClWT/ixrLte3RJs4pegIsIoTtAzDyoSfl
         04qD9NOiMVhIsImJGyvIA0OCIfqmsFkHN2iD8eg8y+G2iLiTtI4gUTiD1PqyXlacfcFO
         C6YRMNj79I1cdZ6Pal7gB1Aq6qb4HayVcZ2FA=
Date: Sun, 30 Nov 2008 00:42:07 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Remi Colinet <remi.colinet@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org,
       linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RESEND][PATCH] Add /proc/mempool to display mempool usage
Message-ID: <20081129214207.GA6747@x200.localdomain>
References: <1227980689.6354.24.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227980689.6354.24.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2008 at 06:44:49PM +0100, Remi Colinet wrote:
> This patch add a new /proc/mempool file in order to display mempool usage.
> 
> The feature can be disabled with CONFIG_PROC_MEMPOOL=N during kernel
> configuration.

We're NOT adding config option per proc file.

And can we, please, freeze /proc for not per-process stuff and open debugfs
for random stuff, please?
