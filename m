Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbXLBTBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbXLBTBW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 14:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbXLBTBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 14:01:14 -0500
Received: from ns1.suse.de ([195.135.220.2]:57693 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbXLBTBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 14:01:13 -0500
To: Avi Kivity <avi@argo.co.il>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
From: Andi Kleen <andi@firstfloor.org>
References: <474EAD18.6040408@stellatravel.co.uk>
	<20071130143445.GA2310@csclub.uwaterloo.ca>
	<53ADBDBF-9B65-441E-B867-D68DE48ABD64@mac.com>
	<4751BE0D.3050609@argo.co.il>
Date: Sun, 02 Dec 2007 20:01:12 +0100
In-Reply-To: <4751BE0D.3050609@argo.co.il> (Avi Kivity's message of "Sat\, 01 Dec 2007 22\:03\:25 +0200")
Message-ID: <p733aukyl8n.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@argo.co.il> writes:
>
> [I really doubt there are that many of these; syscall
> entry/dispatch/exit, interrupt dispatch, context switch, what else?]

Networking, block IO, page fault, ... But only the fast paths in these 
cases. A lot of the kernel is slow path code and could probably
be written even in an interpreted language without much trouble.

-Andi
