Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbYIBVDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbYIBVDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 17:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYIBVCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 17:02:50 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:21470 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbYIBVCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 17:02:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=CT/RS325FWXpGUSYKPWFCo3KTPlf3TKdtAy3k4mcG4tnoPTsJq3l2qLPa5ZY0CsRq4
         fkhxgesopeAxk5GfAPQgU1bQZEsqnI4rFP1IwriF6CMNmdzG1W/pdFtt3ywvEIirtwtQ
         oBOyECsv/H4lKTR+D6pae6Xl2PCt1/04v2YUM=
Message-ID: <48BDA9F2.7000203@gmail.com>
Date: Tue, 02 Sep 2008 23:02:42 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc5-mmotm0829 - CONFIG_HID_COMPAT causes hangs at boot
References: <7419.1220261347@turing-police.cc.vt.edu>            <48BD4D20.5020704@gmail.com> <13476.1220371878@turing-police.cc.vt.edu>
In-Reply-To: <13476.1220371878@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2008 06:11 PM, Valdis.Kletnieks@vt.edu wrote:
> The following 3 lines don't go to console by default due to loglevel setting.
> So I'm not sure exactly where it hangs. But it's somewhere in here.

You may use `ignore_loglevel', `debug' or `loglevel=7' kernel parameter.

>>> [    1.945217] generic-usb 0003:045E:0023.0001: input,hidraw0: USB HID v1.00 Mouse [Microsoft Microsoft Trackball Optical®] on usb-0000:00:1d.7-8.1/input0
>>> [    1.959193] usbcore: registered new interface driver usbhid
>>> [    1.973037] usbhid: v2.6:USB HID core driver
> 
> This line *should* make it to the console, but doesn't. So the failure is
> before this point.
>>> [    1.987014] Advanced Linux Sound Architecture Driver Version 1.0.18rc1.
> 
> I'll go back and instrument it more heavily so there's more info available.

Ok, thanks.
