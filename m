Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbXFYXen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbXFYXen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 19:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbXFYXeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 19:34:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40558 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbXFYXef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 19:34:35 -0400
Date: Tue, 26 Jun 2007 01:34:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Andi Kleen <andi@firstfloor.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Message-ID: <20070625233433.GA32306@one.firstfloor.org>
References: <200706251434.43863.jesse.barnes@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706251434.43863.jesse.barnes@intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch fixes a bug in the last patch that caused the code to
> run on non-Intel machines (AMD machines apparently don't need it

Actually the problem can happen on AMD too, but the symptoms can
be different and there can be more wrong than just the MTRRs.

-Andi
