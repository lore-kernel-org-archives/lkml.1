Return-Path: <linux-kernel-owner+w=401wt.eu-S935438AbZAPBVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935438AbZAPBVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 20:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758702AbZAPBU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 20:20:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42706 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758594AbZAPBU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 20:20:57 -0500
Date: Fri, 16 Jan 2009 01:20:56 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: sameo@openedhand.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Mark WM835x USB_SLV_500MA bit as accessible
Message-ID: <20090116012056.GB16544@opensource.wolfsonmicro.com>
References: <1231944901-4901-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20090115160200.1d6a0c93.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115160200.1d6a0c93.akpm@linux-foundation.org>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 04:02:00PM -0800, Andrew Morton wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > -	{ 0xFCF7, 0xFCF7, 0xF800 }, /* R4   - System Control 2 */
> > +	{ 0xFEF7, 0xFEF7, 0xF800 }, /* R4   - System Control 2 */

> Why?

The code is out of sync with the silicon - this table provides the
driver with a map of what access is provided in hardware, the fact that
this was masked off is a bug in the driver.
