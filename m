Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbZIHIBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbZIHIBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 04:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbZIHIBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 04:01:38 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35397 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbZIHIBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 04:01:37 -0400
To: stern@rowland.harvard.edu
CC: miklos@szeredi.hu, alan@linux.intel.com, gregkh@suse.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <Pine.LNX.4.44L0.0909072138340.13297-100000@netrider.rowland.org>
	(message from Alan Stern on Mon, 7 Sep 2009 21:43:15 -0400 (EDT))
Subject: Re: WARNINGs in usb-serial.c
References: <Pine.LNX.4.44L0.0909072138340.13297-100000@netrider.rowland.org>
Message-Id: <E1Mkvdt-00025I-Im@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 08 Sep 2009 10:01:33 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Sep 2009, Alan Stern wrote:
> 
> You're right; serial_open() is somehow calling usb_serial_put().
> 
> But in my version of the code there's no way for that to happen.  Could 
> it be that your version is different from mine?  For comparison, here 
> is my copy of serial_open().

Argh... I didn't apply 8/8 of your series.

Now everything seems to be working fine (I still get the WARNING's but
that appears to be normal).  Sorry for the noise.

Thanks,
Miklos
