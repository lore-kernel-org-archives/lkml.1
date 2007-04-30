Return-Path: <linux-kernel-owner+w=401wt.eu-S1423295AbXD3Ofg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423295AbXD3Ofg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 10:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423320AbXD3Ofg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 10:35:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:58048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423295AbXD3Oex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 10:34:53 -0400
To: Juergen Beisert <juergen127@kreuzholzen.de>
Cc: linux-kernel@vger.kernel.org, Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [PATCH] [1/1] CPU-i386-Geode: Chipset access macros do not work as expected
References: <200704301509.58776.juergen127@kreuzholzen.de>
From: Andi Kleen <andi@firstfloor.org>
Date: 30 Apr 2007 17:32:04 +0200
In-Reply-To: <200704301509.58776.juergen127@kreuzholzen.de>
Message-ID: <p73odl5zxmz.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Juergen Beisert <juergen127@kreuzholzen.de> writes:

> From: Juergen Beisert <juergen.beisert@weihenstephan.org>
> 
> Replace NSC/Cyrix specific chipset access macros by inlined functions.
> With the macros a line like this fails (and does nothing):
> 	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
> With inlined functions this line will work as expected.

Why do the macros not work? 

-Andi
