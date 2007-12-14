Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbXLNSKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbXLNSKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbXLNSKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:10:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43069 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbXLNSKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:10:07 -0500
Date: Fri, 14 Dec 2007 19:10:23 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071214181022.GA16351@one.firstfloor.org>
References: <20071214004442.5f9eba88@linux360.ro> <p737ijigr8c.fsf@bingen.suse.de> <20071214143941.2c7dcfb4@linux360.ro> <20071214101720.GA10981@one.firstfloor.org> <20071214154106.4f0b2d8c@linux360.ro> <20071214122048.GA12550@one.firstfloor.org> <20071214180119.4c492f6c@linux360.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214180119.4c492f6c@linux360.ro>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> LAPIC is seemingly disabled (C1E detection code does this), but

It should only disable the LAPIC timer, but not the full use of the
LAPIC. 

-Andi
