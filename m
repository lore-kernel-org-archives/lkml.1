Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbYGYOqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbYGYOqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 10:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYGYOqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 10:46:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:37278 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbYGYOqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 10:46:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BMZFHFNfokoAPPS5ct4x0a1hzib3JyemQEC88oIaN3jqJWQr/B64pZXRmsyv4d78ns
         wuePAPgAjCR+AOloKyoPjsl2/1Qe4BNqRqJDRkS5GctMc9P68IFh7zltgDlg+ea+E4Dp
         hNW1b1Oqnsutff6ME3cua+Pwf9asD2uDP0EGg=
Message-ID: <9e4733910807250746g436307d7sbbf799b73a9f2c67@mail.gmail.com>
Date: Fri, 25 Jul 2008 10:46:11 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Grant Likely" <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3 0/4 REPOST] OF infrastructure for SPI devices
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net, linuxppc-dev@ozlabs.org
In-Reply-To: <20080725072549.8485.90723.stgit@trillian.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080725072549.8485.90723.stgit@trillian.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/08, Grant Likely <grant.likely@secretlab.ca> wrote:
> I don't know what to do with these patches.  I'd really like to see them
>  in .27, and now that akpm has cleared his queue, the prerequisite patch
>  has been merged so they are ready to go in.  However, even though there
>  has been favourable reception on the SPI and linuxppc lists for these
>  changes I don't have any acks from anybody yet.

I have compatible hardware but it has an MMC card socket hooked up. I
haven't figured out yet how to get this driver hooked to the MMC
subsystem and make the file system on the card work.  (I've been
working on ALSA).

I believe I need this:
http://lkml.org/lkml/2008/6/5/209

Then I need to get everything hooked together. Point me in the right
direction and I can help with testing.


>
>  David, can you please reply on if you are okay with these patches
>  getting merged?  If so, do you want me to merge them via my tree, or
>  do you want to pick them up?
>
>  Thanks,
>  g.
>
>  --
>  Grant Likely, B.Sc. P.Eng.
>  Secret Lab Technologies Ltd.
>
> --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Jon Smirl
jonsmirl@gmail.com
