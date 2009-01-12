Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbZALBol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbZALBol (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 20:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbZALBoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 20:44:30 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:42629 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbZALBo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 20:44:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=mBUO5gsYiDblS0iN6qMfTNFw9Ric1xIHatA02lR1Oz7Z5Zeve4A1MnoM/O11DgRUxw
         WaTa7HwKcLjml4WmuibshF8DoHQTi7nY2bQ4QkUygutnrRVAiX157eTGIAN/P9bU7iVg
         u+MPhVVLAwROWGn00G1Z8Z75ejZvWa35AzHM4=
Message-ID: <496AA076.8080205@gmail.com>
Date: Mon, 12 Jan 2009 10:44:22 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Soeren Sonnenburg <kernel@nn7.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux-ide <linux-ide@vger.kernel.org>
Subject: Re: Do ICH10+AHCI-driver support port-multiplying on a eSATA port?
References: <1231513287.2631.68.camel@localhost>
In-Reply-To: <1231513287.2631.68.camel@localhost>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soeren Sonnenburg wrote:
> Dear all,
> 
> I am trying to connect an external 2-disk case (eCube II  see
> http://www.one-tech.com/EN/htm_ecube.htm) to an ICH10 skyburg dp45sg
> board via eSATA. As the case requires a port-multiplying sata card, I am
> wondering if ich10+ahci support it?
> 
> At least with 2.6.27.10 I am seeing only one drive. Connecting the case
> via usb gives two (dmesg parts below).
> 
> So is port multiplying not yet available for ahci or not at all or does
> the the ich10 not support it and I should rather try a sil 3132 or so?

ahci on ich10 can do port multiplier.  I can't tell from the web page
but if it's one of simg5723 and its friends, you'll need to put it
into JBOD mode using the dip switch or whatever.

-- 
tejun
