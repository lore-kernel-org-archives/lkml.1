Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbZFANeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbZFANeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 09:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757285AbZFANe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 09:34:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33496 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757282AbZFANe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 09:34:27 -0400
Date: Mon, 1 Jun 2009 14:35:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 2/2] usb_serial: only allow sysrq on a console port
Message-ID: <20090601143538.70b7a4e2@lxorguk.ukuu.org.uk>
In-Reply-To: <1243622057-17671-3-git-send-email-jason.wessel@windriver.com>
References: <1243622057-17671-1-git-send-email-jason.wessel@windriver.com>
	<1243622057-17671-2-git-send-email-jason.wessel@windriver.com>
	<1243622057-17671-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 May 2009 13:34:17 -0500
Jason Wessel <jason.wessel@windriver.com> wrote:

> The only time a sysrq should get processed is if the attached device
> is a console.  This is intended to protect sysrq execution on a host
> connected with a terminal program.

This doesn't seem to match any tree I can find ?
