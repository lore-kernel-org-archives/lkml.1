Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbZCIORQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbZCIORQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 10:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbZCIOQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 10:16:58 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:45146 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbZCIOQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 10:16:58 -0400
Date: Mon, 9 Mar 2009 14:16:55 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux* Processor Microcode Data File
Message-ID: <20090309141655.GA24213@silver.sucs.org>
References: <2d05c4580903090243k6cf73ee9ubb6c4fccf0f07a2f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d05c4580903090243k6cf73ee9ubb6c4fccf0f07a2f@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 10:43:57AM +0100, Dragoslav Zaric wrote:

> So, does new kernel versions just copy this microcode update file in
> /etc/firmware folder or new
> instructions are replaced in assembly code ?

The kernel doesn't load microcode automatically but it can provide a
device to allow userspace to trigger a microcode update (via
/dev/cpu/microcode ). On boot the patching process is normally started
by an initscript. See http://www.urbanmyth.org/microcode/ for details.

-- 
Sitsofe | http://sucs.org/~sits/
