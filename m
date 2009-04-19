Return-Path: <linux-kernel-owner+w=401wt.eu-S1761195AbZDSPut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761195AbZDSPut (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 11:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758033AbZDSPuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 11:50:39 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:55949 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080AbZDSPui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 11:50:38 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: linux-2.6.30rc1 mouse stuck with usb autosuspend enabled
Date: Sun, 19 Apr 2009 17:50:55 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: linux-usb@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
       "Linux-Kernel" <linux-kernel@vger.kernel.org>
References: <4e5e476b0904091453m61ec4e81j7cfdef918bb3dfb3@mail.gmail.com> <200904161543.06238.oliver@neukum.org> <4e5e476b0904190629s356a23bdw510f97510717d6b9@mail.gmail.com>
In-Reply-To: <4e5e476b0904190629s356a23bdw510f97510717d6b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904191750.56137.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 19 April 2009 15:29:28 schrieb Corrado Zoccolo:
> On Thu, Apr 16, 2009 at 3:43 PM, Oliver Neukum <oliver@neukum.org> wrote:
> > Am Donnerstag 16 April 2009 14:45:12 schrieb Corrado Zoccolo:
> > This is not the reliable way to check this. Please compile 2.6.29 with
> > CONFIG_USB_DEBUG and post dmesg for a period of inactivity.
>
> Oliver, you were right: 2.6.29 did not attempt at all to suspend the
> mouse and its attached hum (2-x):

OK, so this is confirmed to not be a regression.

I am sorry that your mouse doesn't support better power management.
The behavior you report is typical. I suggest that you couple autosuspend
of your mouse with the screensaver, if your desktop supports that. If not,
you might want to talk to the screensaver's developers.

	Regards
		Oliver

