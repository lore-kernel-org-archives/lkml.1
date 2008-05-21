Return-Path: <linux-kernel-owner+w=401wt.eu-S933810AbYEUL6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933810AbYEUL6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 07:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761259AbYEUL60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 07:58:26 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:2720 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759123AbYEUL6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 07:58:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U1bu36XrCw5OREJjnddxevTskEPsYjhIS/IbNsb6UEogI/K/sWoOvx3Rrv+C3cjulcVYIRTdsVnH7Bdc4583Jv82i5iB7LWIQWPcN5py2bzCmd5S/WaBkUyQWzu9LUeyxRDMAiA4g9WK8SFBKf7voHObjg78LFON/3uyvcvmJaY=
Message-ID: <aec7e5c30805210458m3d15b89am563e4a94b8eb6f2c@mail.gmail.com>
Date: Wed, 21 May 2008 20:58:24 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/03] uio: Add enable_irq() callback
Cc: linux-sh@vger.kernel.org, "Magnus Damm" <magnus.damm@gmail.com>,
       lethal@linux-sh.org, hjk@linutronix.de, gregkh@suse.de,
       "=?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=" <Uwe.Kleine-Koenig@digi.com>
In-Reply-To: <20080520105140.1474.59715.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080520105132.1474.73941.sendpatchset@rx1.opensource.se>
	 <20080520105140.1474.59715.sendpatchset@rx1.opensource.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 7:51 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
> Add enable_irq() callback to struct uio_info. This callback is needed by
> the uio_platform driver so interrupts can be enabled before blocking.

We can most likely use a single uio platform driver if this patch is
acceptable. Any NAKs?

Thanks,

/ magnus
