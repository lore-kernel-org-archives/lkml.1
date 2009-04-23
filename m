Return-Path: <linux-kernel-owner+w=401wt.eu-S1758324AbZDWNMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324AbZDWNMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 09:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbZDWNM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 09:12:26 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:50930 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758324AbZDWNMX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 09:12:23 -0400
From: Oliver Neukum <oliver@neukum.org>
To: =?utf-8?q?Mar=C3=B3y_=C3=81kos?= <akos@maroy.hu>
Subject: Re: cdc-acm driver hangs on poll() call - 2.6.27, works on 2.6.24
Date: Thu, 23 Apr 2009 15:11:53 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <49EDC44D.90106@maroy.hu> <200904221514.34892.oliver@neukum.org> <49EF1AAC.3080802@maroy.hu>
In-Reply-To: <49EF1AAC.3080802@maroy.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904231511.54024.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 22 April 2009 15:25:00 schrieb Maróy Ákos:
> Oliver,
>
> > That's odd. I can't tell from the log. Can you make a usbmon trace?
>
> sure:
>
> cat /sys/kernel/debug/usbmon/1u

Please try setting ACM_NW in cdc-acm.h to 1. If that does not help,
please provide an usbmon trace of that modified kernel and 2.6.24.

	Regards
		Oliver

