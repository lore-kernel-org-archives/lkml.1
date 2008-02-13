Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbYBMH4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbYBMH4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYBMH4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:56:12 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59315 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432AbYBMH4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:56:11 -0500
Date: Tue, 12 Feb 2008 23:54:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [2.6.25-rc1] System no longer powers off after shutdown
Message-Id: <20080212235442.005aea9e.akpm@linux-foundation.org>
In-Reply-To: <200802122245.09444.elendil@planet.nl>
References: <200802111623.38478.elendil@planet.nl>
	<200802122139.14840.elendil@planet.nl>
	<20080212205622.GA21986@suse.de>
	<200802122245.09444.elendil@planet.nl>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 22:45:09 +0100 Frans Pop <elendil@planet.nl> wrote:

> Symptom is that the system shuts down normally and completely, it just does 
> not power off.

I've been struggling with an identically-manifesting regression on one of
my test machines for a week.  It's due to softlockup changes, and setting
CONFIG_DETECT_SOFTLOCKUP=n "fixes" it.

It sounds unlikely, but I'd suggest that you see if it's the same on your
machine so we're not both chasing the same bug.

