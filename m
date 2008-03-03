Return-Path: <linux-kernel-owner+w=401wt.eu-S1762021AbYCCXFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762021AbYCCXFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 18:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756033AbYCCXFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 18:05:37 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34783 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754950AbYCCXFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 18:05:36 -0500
Date: Mon, 3 Mar 2008 18:05:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
cc: Pierre Ossman <drzeus-list@drzeus.cx>, LKML <linux-kernel@vger.kernel.org>,
       Adam Belay <abelay@novell.com>, Andi Kleen <andi@firstfloor.org>,
       Lee Revell <rlrevell@joe-job.com>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEA2E8B2@orsmsx423.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Pallipadi, Venkatesh wrote:

> But, with this patch:
> - we are penalizing good hardware and making them less power efficient
> to match the bad ones.
> - There may also be server systems which first may not have these sort
> of power fluctuations and even when buggy and have this noise, system
> may be in some corner of some lab with fans making more noise than the
> capacitors.

Can you make it configurable through sysfs?  Default to disabled, but 
allow the user to turn it on if the machine makes too much noise.

Alan Stern

