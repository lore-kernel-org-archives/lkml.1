Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbZAVRIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbZAVRIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZAVRIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:08:14 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:37786 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbZAVRIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:08:13 -0500
Subject: Re: [PATCH] regulator: add unset_regulator_supplies to fix
 regulator_unregister
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mike Rapoport <mike@compulab.co.il>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mark Brown <mark.brown@wolfsonmicro.com>
In-Reply-To: <49787BFD.3020702@compulab.co.il>
References: <49787BFD.3020702@compulab.co.il>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 17:08:09 +0000
Message-Id: <1232644089.16911.374.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-22 at 16:00 +0200, Mike Rapoport wrote:
> Currently regulator_unregister does not clear regulator <--> consumer
> mapping.
> This patch introduces unset_regulator_supplies that clear the map.
> 
> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> ---
>  drivers/regulator/core.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 

Applied.

Thanks

Liam

