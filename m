Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbYAIGDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbYAIGDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 01:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbYAIGC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 01:02:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54465 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbYAIGC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 01:02:59 -0500
Date: Wed, 9 Jan 2008 07:05:28 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Change x86 Machine check handler to use unlocked_iocl instead of ioctl
Message-ID: <20080109060528.GA8202@one.firstfloor.org>
References: <4785B342.2070501@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4785B342.2070501@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 11:25:14AM +0530, Nikanth Karthikesan wrote:
> The Machine check handler registers ioctl handler that is called
> with the BKL held. Changing to register unlocked_ioctl instead.
> Also mce ioctl handler does not seem to need any lock protection.

Thanks, but I already did that here on my own.

-Andi
