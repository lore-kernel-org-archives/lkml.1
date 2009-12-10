Return-Path: <linux-kernel-owner+w=401wt.eu-S1761251AbZLJRuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761251AbZLJRuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 12:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761195AbZLJRuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 12:50:18 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46980 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761183AbZLJRuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 12:50:17 -0500
Date: Thu, 10 Dec 2009 17:50:07 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH] ARM: Convert BUG() to use unreachable()
Message-ID: <20091210175007.GC13210@n2100.arm.linux.org.uk>
References: <1260266138-17684-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1260266138-17684-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 10:55:38AM +0100, Uwe Kleine-König wrote:
> Use the new unreachable() macro instead of for(;;);

Have you investigated what effect this has on generated code?
