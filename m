Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbZCIPfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbZCIPfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 11:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbZCIPey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 11:34:54 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:33559 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbZCIPex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 11:34:53 -0400
Date: Mon, 9 Mar 2009 15:34:50 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux* Processor Microcode Data File
Message-ID: <20090309153449.GB24213@silver.sucs.org>
References: <2d05c4580903090243k6cf73ee9ubb6c4fccf0f07a2f@mail.gmail.com> <20090309141655.GA24213@silver.sucs.org> <20090309081109.376f7a7e@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090309081109.376f7a7e@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 08:11:09AM -0700, Arjan van de Ven wrote:
> On Mon, 9 Mar 2009 14:16:55 +0000
> Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> 
> > The kernel doesn't load microcode automatically 
> 
> it does if you have the right format; the kernel uses
> request_firmware() for this.
> The microcode on the intel website is not ready for this yet, but we're
> working hard to have future drops to be in the new format.

Wow so I was redundant AND wrong in the same email!

What motivated the switch to the generic request_firmware interface? Is
it just less messy/faster than previous methods?

Additionally while I remember, is it worth updating the microcode on all
machines? At present I have an EeePC 900 and it's unclear if it would
benefit from a microcode update (but there's a definite cost to running
the current initscript at boot).

-- 
Sitsofe | http://sucs.org/~sits/
