Return-Path: <linux-kernel-owner+w=401wt.eu-S933094AbXBLIEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094AbXBLIEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 03:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933092AbXBLIEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 03:04:48 -0500
Received: from cantor.suse.de ([195.135.220.2]:39666 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933088AbXBLIEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 03:04:47 -0500
From: Andi Kleen <ak@suse.de>
To: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH x86 for review II] [18/39] x86_64: Allow to run a program when a machine check event is detected
Date: Mon, 12 Feb 2007 09:04:43 +0100
User-Agent: KMail/1.9.5
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <20070212837.963446000@suse.de> <20070212073805.89FEE13D7F@wotan.suse.de> <200702120854.15814.oneukum@suse.de>
In-Reply-To: <200702120854.15814.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702120904.43287.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 February 2007 08:54, Oliver Neukum wrote:
> Am Montag, 12. Februar 2007 08:38 schrieb Andi Kleen:
> > When a machine check event is detected (including a AMD RevF threshold 
> > overflow event) allow to run a "trigger" program. This allows user space
> > to react to such events sooner.
> 
> Could this not be merged with other reporting mechanisms? This looks like
> a new incarnation of the /etc/hotplug code.

I refuse to make mcelog depend on dbus. Just because some desktops want bloat
doesn't mean that everybody else wants too.

I don't know of any other lightweight mechanism except for this.

-Andi
