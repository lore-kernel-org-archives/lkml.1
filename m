Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbZIABho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbZIABho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 21:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbZIABho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 21:37:44 -0400
Received: from mail-pz0-f175.google.com ([209.85.222.175]:59000 "EHLO
	mail-pz0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbZIABhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 21:37:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=Wv/JlBVN7l3S8fD06mO8uUCeKXCr+KMT2ZSHdImh/DhWugJUWofpmmob70Wf+HconD
         oMtPLpx5zWeSgkc1yKiw+xcSA0R8jWX9+r1h42hX+n2+6jR314L2Ywn5IWQFoQqTWs9V
         LqYl6zQMkftVfuz8JaMSstsCpsK3GspSnZmco=
Date: Mon, 31 Aug 2009 18:37:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Georgi Chorbadzhiyski <gf@unixsol.org>
Cc: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Add support for Rotronic silver/white handset
	in cm109 driver
References: <4A9ACD69.5030501@unixsol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9ACD69.5030501@unixsol.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090901021017.26A96526EA5@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Georgi,

On Sun, Aug 30, 2009 at 10:05:13PM +0300, Georgi Chorbadzhiyski wrote:
> The following patch adds support for yet another keymap in
> cm109 driver. Rotronic silver/white is USB "Skype" handset
> sold in Bulgaria and Serbia (according to Google). With this
> cheap stuff a picture is the only way to identify what you've
> got, so here is one:
>    http://www.reset.bg/catalog/images/skyphoneusbbelihcek.jpg
> 

While there is nothing wrong with the patch I am hesitant to apply it.
Any chance we could push it onto HAL or maybe have your application to
load appropriate keymap? I know we can't do it automatically because
vendor and product IDs are the same for all these devices... It's just
putting every keymap into the kernel is not sustainable.

-- 
Dmitry
