Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbYJVNDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbYJVNDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 09:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbYJVNDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 09:03:11 -0400
Received: from styx.suse.cz ([82.119.242.94]:47036 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752059AbYJVNDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 09:03:09 -0400
Date: Wed, 22 Oct 2008 15:03:08 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steven Noonan <steven@uplinklabs.net>,
       Justin Mattock <justinmattock@gmail.com>,
       Sven Anders <anders@anduras.de>, Marcel Holtmann <marcel@holtmann.org>,
       linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 2/4] HID: fix appletouch regression
In-Reply-To: <1224624363-16471-2-git-send-email-jirislaby@gmail.com>
Message-ID: <alpine.LNX.1.10.0810221502440.27479@jikos.suse.cz>
References: <1224624363-16471-1-git-send-email-jirislaby@gmail.com> <1224624363-16471-2-git-send-email-jirislaby@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008, Jiri Slaby wrote:

> The appletouch mouse devices are grabbed by the hid bus and not
> released even if apple driver says ENODEV (as expected).
> Move the ignoration one level upper to deny the hid layer to grab
> the device and return error to the usb hid which, as a result,
> releases the device.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
