Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbZGBAdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbZGBAdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 20:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZGBAc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 20:32:59 -0400
Received: from mail-vw0-f202.google.com ([209.85.212.202]:50928 "EHLO
	mail-vw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbZGBAc6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 20:32:58 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jul 2009 20:32:58 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LdEHs6Ca0uRQnbCWHG6aH1nPSMPjai/t2zEyJ53Vt8KFRLSbmm30HFWOrRxQ0E2yUn
         SausvSGK+SpioffIRtcRT1ZUawfoG+RqikpDq9f58uboaRNVfFwR1QXrvJdv2aFl2CnW
         z15XuKz7izEr3bIfkwWm1qkscXU7KtaQ8mG74=
MIME-Version: 1.0
In-Reply-To: <adar5x0ffds.fsf@cisco.com>
References: <adar5x0ffds.fsf@cisco.com>
Date: Wed, 1 Jul 2009 17:26:40 -0700
X-Google-Sender-Auth: 17c0f4493ec71aa2
Message-ID: <e9c3a7c20907011726n794308bcy774b3fff3e75b5b9@mail.gmail.com>
Subject: Re: [PATCH] Add MODULE_DEVICE_TABLE() so ioatdma module is autoloaded
From: Dan Williams <dan.j.williams@intel.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: maciej.sosnowski@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 1, 2009 at 11:05 AM, Roland Dreier<rdreier@cisco.com> wrote:
> The ioatdma module is missing aliases for the PCI devices it supports,
> so it is not autoloaded on boot.  Add a MODULE_DEVICE_TABLE() to get
> these aliases.
>
> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> ---
> Not sure if not autoloading was intentional or if it's just an
> oversight, but this patch seems useful to me, so please apply if it
> makes sense to you.
>

Makes sense.  I believe the only hesitation is that it is a bit
awkward to remove (ifdown all interfaces, stop all raid456 arrays).
However, unless Maciej disagrees I think we should go ahead and
autoload it.

Applied for now to the 'fixes' branch of async_tx.git.

Thanks,
Dan
