Return-Path: <linux-kernel-owner+w=401wt.eu-S1752507AbZAZMAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbZAZMAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 07:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbZAZMAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 07:00:23 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:40205 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZAZMAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 07:00:22 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Ed W <lists@wildgooses.com>, linux-usb@vger.kernel.org
Subject: Re: How to add new CDC-ACM usb modem device to supported list?
Date: Mon, 26 Jan 2009 13:00:51 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <497D94C0.3070308@wildgooses.com> <497D9CAE.3010503@wildgooses.com>
In-Reply-To: <497D9CAE.3010503@wildgooses.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901261300.51560.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Monday 26 January 2009 12:21:18 schrieb Ed W:
 
> dmesg
> [5075781.727325] usb 6-2: new full speed USB device using uhci_hcd and
> address 8
> [5075781.911917] usb 6-2: configuration #1 chosen from 1 choice
> [5075781.915864] hci_usb: probe of 6-2:1.0 failed with error -5
> [5075781.915879] cdc_acm 6-2:1.0: ttyACM0: USB ACM device
> 
> 
> Presumably this error -5 is relevant??

That is from hci_usb, the old bluetooth dongle driver. Why this probes your
device I don't know, but it should work anyway. The cdc-acm driver can
be compiled with extra debugging. It has the lines:

#undef DEBUG
#undef VERBOSE_DEBUG

If you replace #undef with #define you get more debugging output.

	Regards
		Oliver
