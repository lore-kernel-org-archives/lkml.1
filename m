Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbYKYLjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbYKYLjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 06:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYKYLjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 06:39:07 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:38588 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbYKYLjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:39:06 -0500
Subject: Re: [PATCH] regulator: move set_machine_constraints after
 regulator device initialization
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mike Rapoport <mike@compulab.co.il>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1227545055-28782-1-git-send-email-mike@compulab.co.il>
References: <1227545055-28782-1-git-send-email-mike@compulab.co.il>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 11:39:03 +0000
Message-Id: <1227613143.585.47.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-24 at 18:44 +0200, Mike Rapoport wrote:
> Calling set_machine_constraints before regulator device initialization
> causes crash when constraints have apply_uV set.
> 
> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> ---

There have been recent changes to regulator registration in the
regulator for-next branch. Does this crash still occur with for-next.

git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git #for-next

Liam

