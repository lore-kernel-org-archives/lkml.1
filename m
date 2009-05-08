Return-Path: <linux-kernel-owner+w=401wt.eu-S1760682AbZEHVrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760682AbZEHVrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755613AbZEHVrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:47:41 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:59502 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201AbZEHVrk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:47:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ruUy0GOqzDSgoM2oY5/vIs6fJMweLbrXS7Ijt1Bt9PA36hXF3/asvEPUB8z7Z1FSq/
         isKvtPPZpY5XYdKkxUvFd9cvRa/5Kmz7w1y3FA+uxMdclCtBtRU5/dDAqtc3Cl64inmE
         vxdrebMtxgbzZD6YCPvDdnMkPlRVwOKxT81gM=
MIME-Version: 1.0
In-Reply-To: <gu017d$g2s$1@ger.gmane.org>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <20090507120948.GA1531@ucw.cz> <200905080037.19722@centrum.cz>
	 <gu017d$g2s$1@ger.gmane.org>
Date: Fri, 8 May 2009 23:47:39 +0200
Message-ID: <b637ec0b0905081447w23f0d9afw2dcd71ba59fb4463@mail.gmail.com>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Shannon McMackin <smcmackin@gmail.com>
Cc: tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, May 8, 2009 at 3:17 AM, Shannon McMackin <smcmackin@gmail.com> wrote:
...
> Just to add my 2 cents as a user of TOI.  Every distro and release I've
> tried has one major issue with kernel hibernation.  Upon resume when
> hibernating large images, there's a residual footprint in swap.  Every
> further hibernation creates a larger footprint, to the order of an
> additional 5-7% each time.  Nobody has ever cared in any forum to
> explain why or how I might change that.
>

Actually I'm not seeing this with uswsusp and 2.6.29.2:

fcomolli@hawking:~> dmesg|grep 'Preparing to enter system sleep state S4'
ACPI: Preparing to enter system sleep state S4
ACPI: Preparing to enter system sleep state S4
ACPI: Preparing to enter system sleep state S4
fcomolli@hawking:~> free
             total       used       free     shared    buffers     cached
Mem:       2039692     901252    1138440          0     118980     395236
-/+ buffers/cache:     387036    1652656
Swap:      2104504          0    2104504

I limit the image size to 950M.

Regards,
Fabio
