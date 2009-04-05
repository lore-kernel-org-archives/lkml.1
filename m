Return-Path: <linux-kernel-owner+w=401wt.eu-S1758372AbZDEH77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372AbZDEH77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 03:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757555AbZDEH7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 03:59:48 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:30087 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439AbZDEH7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 03:59:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Q//mHbuX5MF55hrOcQevSKKE25eI9TOcKnB8iip35YezxNoV1xHEGN07I4wZVd48Vu
         R7W5yvYTPz8deqkAxw++EdBQGvrkv3TvkFSM+YDuN8n8p/4/FYeTrTKJTsFAWNQ0H5if
         vCw4IC0+hTDzfujWAjHa1Re94H7c1zkUg0CJQ=
MIME-Version: 1.0
In-Reply-To: <200904042337.31706.rjw@sisk.pl>
References: <200904042337.31706.rjw@sisk.pl>
Date: Sun, 5 Apr 2009 00:59:44 -0700
X-Google-Sender-Auth: 072516a275673e54
Message-ID: <9929d2390904050059t4f38428fn145aa615f850dd1f@mail.gmail.com>
Subject: Re: [RFT][PATCH 0/3] NET: Shutdown fixes for e1000, e1000e and ixgbe
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: NetDev <netdev@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       Yinghai Lu <yinghai@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 4, 2009 at 2:37 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Hi,
>
> Commit 3fe7c4c9dca4fbbff92eb61a660690dad7029ec3 (net/igb: Fix kexec with igb
> (rev. 3)) fixed a kexec problem with igb by making its shutdown routine only
> put the device into a low power state if the system is going to be powered off.
>
> The following three patches make analogous changes to e1000, e1000e and ixgbe.
>

Thanks Rafael, I will add these patches to my tree and get them into
testing on Monday/Tuesday.  If everything looks good after testing, I
will push them with our other patches.

-- 
Cheers,
Jeff
