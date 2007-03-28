Return-Path: <linux-kernel-owner+w=401wt.eu-S965703AbXC1TI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965703AbXC1TI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 15:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965699AbXC1TI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 15:08:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:45133 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965695AbXC1TIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 15:08:43 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Konrad Rzeszutek <konrad@darnok.org>
Subject: Re: [PATCH] Inhibit machine from asserting an NMI when doing Alt-SysRq-M operation.
Date: Wed, 28 Mar 2007 20:56:40 +0200
User-Agent: KMail/1.9.5
References: <20070327134508.GA21548@andromeda.dapyr.net>
In-Reply-To: <20070327134508.GA21548@andromeda.dapyr.net>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703282056.40716.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 March 2007 15:45, you wrote:
> This patch touches the NMI watchdog every MAX_ORDER_NR_PAGES
> to inhibit the machine from triggering an NMI while the CPUs
> are locked. This situation is happening on boxes with more 
> than 64CPUs and 128GB of RAM when Alt-SysRq-m is performed.
> 
> It has been succesfully tested for regression on uni, 2, 4, 8 
> 32, and 64 CPU boxes with various memory configuration.

Applied thanks

-Andi
