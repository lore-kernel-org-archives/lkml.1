Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbZCDLlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbZCDLlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 06:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbZCDLlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 06:41:05 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:37105 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbZCDLlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 06:41:04 -0500
Subject: Re: [PATCH 1/2] regulator: Allow boot_on regulators to be disabled
 by clients
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1236011567-31311-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1236011567-31311-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 11:40:58 +0000
Message-Id: <1236166858.6781.1.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 16:32 +0000, Mark Brown wrote:
> Rather than incrementing the reference count for boot_on regulators
> (which prevents them being disabled later on) simply force the
> regulator to be enabled when applying the constraints. Previously
> boot_on was essentially equivalent to always_on.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c          |   13 ++++---------
>  include/linux/regulator/machine.h |    4 +++-
>  2 files changed, 7 insertions(+), 10 deletions(-)

Applied.

Thanks

Liam

