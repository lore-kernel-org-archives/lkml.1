Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432Ab0A0PfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab0A0PfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 10:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329Ab0A0PfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 10:35:13 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:41154 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328Ab0A0PfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 10:35:10 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Subject: Re: usbhid driver: replacing resume or using a post resume function
Date: Wed, 27 Jan 2010 16:35:26 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: "Jiri Kosina" <jkosina@suse.cz>, "Linux" <linux-kernel@vger.kernel.org>,
       "Linux USB" <linux-usb@vger.kernel.org>
References: <3026aa4769d53c108ee0671f2b17c668.squirrel@intranet.cs.nmsu.edu> <alpine.LRH.2.00.1001270018570.15694@twin.jikos.cz> <fd35fcc83b1a4ae5dd4daba3cf596c5d.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <fd35fcc83b1a4ae5dd4daba3cf596c5d.squirrel@intranet.cs.nmsu.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001271635.26295.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 27. Januar 2010 15:57:48 schrieb Rick L. Vinyard, Jr.:
> I think the most common case would be for something like the G13 to
> re-establish settings, which from the few devices I'm familiar with would
> need to restart the hid subsystem first and then re-establish through
> feature reports, et. al. after the hid_resume().
> 
> Also, that means that usbhid's hid_resume() doesn't need to be exposed in
> the API, or even need to be usb specific.

If you do do this please document that you may use only GFP_NOIO
and GFP_ATOMIC in that context.

	Regards
		Oliver
