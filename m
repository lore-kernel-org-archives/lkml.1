Return-Path: <linux-kernel-owner+w=401wt.eu-S1755722Ab0AWPUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab0AWPUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 10:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755623Ab0AWPUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 10:20:16 -0500
Received: from netrider.rowland.org ([192.131.102.5]:51817 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755563Ab0AWPUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 10:20:15 -0500
Date: Sat, 23 Jan 2010 10:20:14 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] PM / Runtime: Add sysfs switch for disabling device
 run-time PM (rev. 2)
In-Reply-To: <201001231314.54926.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1001231018510.32358-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jan 2010, Rafael J. Wysocki wrote:

> Hmm, OK.
> 
> Of course, if the driver decides to leave disable_depth > 0, the user still
> won't be able to do anything about that, but if I understand correctly, you
> want drivers to have the option to use pm_runtime_forbid() initially, right
> after pm_runtime_enable(), so that the user space can turn the runtime PM
> on if desired via sysfs.
> 
> That makes sense.  I have a usage case for that myself. :-)
> 
> Updated patch is appended.

It looks good.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

