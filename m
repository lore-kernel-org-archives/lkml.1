Return-Path: <linux-kernel-owner+w=401wt.eu-S1758340AbYDOIoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340AbYDOIoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 04:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYDOIoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 04:44:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:58507 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbYDOIoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 04:44:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=u756R+ME9Q+nTydeQZjt1lhjU9a/r02QddpYj8qNMpuuKTi+KCYyo1Jbt9QXmZ/lJ9SZ7k+3UzdpW53QcrgmkvTAPIs9R02QgrdYZpSSMZN5BzruSjRvZ9VZXwyGyWGVvXHHsPb1jXRXou6NdslEn86BRQLaL5b+0ZLSDBWQoow=
Date: Tue, 15 Apr 2008 12:44:02 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pda_power: add init and exit function callbacks
Message-ID: <20080415084402.GA7255@zarina>
Reply-To: cbouatmailru@gmail.com
References: <1208000865.9566.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1208000865.9566.6.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 01:47:45PM +0200, Philipp Zabel wrote:
> This adds init/exit function callbacks to pda_power, to
> provide a place where the platform code can request/free
> GPIOs that it wants to use in the is_ac_online, is_usb_online
> and set_charge functions.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> ---
>  drivers/power/pda_power.c |   11 +++++++++++
>  include/linux/pda_power.h |    2 ++
>  2 files changed, 13 insertions(+), 0 deletions(-)

Applied to battery-2.6.git. Thanks Philipp!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
