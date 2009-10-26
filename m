Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbZJZNcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbZJZNcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 09:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbZJZNcC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 09:32:02 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:10607 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbZJZNcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 09:32:01 -0400
Subject: Re: [PATCH] regulator: Factor out voltage constraint setup
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1255964030-12147-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1255964030-12147-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Oct 2009 13:32:00 +0000
Message-ID: <1256563920.3530.312.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-19 at 15:53 +0100, Mark Brown wrote:
> This allows constraints to take effect on regulators that support
> voltage setting but for which the board does not specify a voltage
> range (for example, because it is fixed correctly at system startup).
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c |   64 ++++++++++++++++++++++++++-------------------
>  1 files changed, 37 insertions(+), 27 deletions(-)

Applied.

Thanks

Liam

