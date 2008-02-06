Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbYBFTHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbYBFTHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbYBFTHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:07:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42111 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005AbYBFTHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:07:03 -0500
Date: Wed, 6 Feb 2008 11:06:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>, Willy Tarreau <w@1wt.eu>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: {2.6.22.y} quicklists must keep even off node pages on the
 quicklists until the TLB flush has been completed.
Message-Id: <20080206110609.591383be.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802061058030.25173@schroedinger.engr.sgi.com>
References: <6101e8c40802051306y24cc7740g4c75508035aaefd@mail.gmail.com>
	<20080206060256.GA3836@linux.vnet.ibm.com>
	<Pine.LNX.4.64.0802061058030.25173@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008 10:58:13 -0800 (PST) Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 6 Feb 2008, Dhaval Giani wrote:
> 
> > Is this one also supposed to be backported?
> 
> Yes.

So mainline's ed367fc3a7349b17354c7acef551533337764859 needs to be backported
to 2.6.23.x.
