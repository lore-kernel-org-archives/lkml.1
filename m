Return-Path: <linux-kernel-owner+w=401wt.eu-S932878AbYAaJ4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878AbYAaJ4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 04:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762624AbYAaJ4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 04:56:06 -0500
Received: from ns1.suse.de ([195.135.220.2]:46887 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761460AbYAaJ4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 04:56:04 -0500
To: Paul Mundt <lethal@linux-sh.org>
Cc: Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Purpose of numa_node?
From: Andi Kleen <andi@firstfloor.org>
References: <47A11ACD.1090400@redhat.com>
	<20080131074045.GA13788@linux-sh.org>
Date: Thu, 31 Jan 2008 10:56:03 +0100
In-Reply-To: <20080131074045.GA13788@linux-sh.org> (Paul Mundt's message of "Thu\, 31 Jan 2008 16\:40\:45 +0900")
Message-ID: <p73zlum48uk.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt <lethal@linux-sh.org> writes:
>
> The in-kernel use looks perfectly sane in that regard, though I'm not
> sure what the point of exporting this as a RO attribute to userspace is.
> Presumably someone has a tool somewhere that cares about this.

The idea was to allow e.g. NUMA aware irqbalanced that directs the interrupts
on the same node as the device is connected to. Don't know if it was
ever actually implemented.

-Andi
 
