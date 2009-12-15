Return-Path: <linux-kernel-owner+w=401wt.eu-S1751888AbZLOOj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbZLOOj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 09:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbZLOOj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 09:39:26 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:5284 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbZLOOjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 09:39:25 -0500
Subject: Re: [PATCH] regulator: Fix unbalanced disables/enables in
 regulator_bulk_{enable,disable} error path
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1260883801-22667-1-git-send-email-lars@metafoo.de>
References: <1260883801-22667-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Dec 2009 14:39:25 +0000
Message-ID: <1260887965.3591.540.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-15 at 14:30 +0100, Lars-Peter Clausen wrote:
> Currently it is possible for regulator_bulk_{enable,disable} operations to
> generate unbalanced regulator_{disable,enable} calls in its error path.
> In case of an error only those regulators of the bulk operation which actually
> had been enabled/disabled should get their original state restored.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/regulator/core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 

Applied for 2.6.33.

Thanks

Liam

