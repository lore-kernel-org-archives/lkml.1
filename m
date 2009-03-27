Return-Path: <linux-kernel-owner+w=401wt.eu-S1763068AbZC0Axh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763068AbZC0Axh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933827AbZC0Awg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:52:36 -0400
Received: from outbound-mail-319.bluehost.com ([67.222.54.251]:46057 "HELO
	outbound-mail-319.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933822AbZC0Awf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:52:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Q/Ukjus8XZ2mGcINaEM8oqknPTFRR8d+D602ePlBik8pzPGAYThO0keGJACgm5Jcvj3d5EEzZIoH5BSCB6nS6IwoYCLzr6tZiSgWfiGKpfK3HMYO907dCys9g0C8jUvy;
Date: Thu, 26 Mar 2009 17:52:30 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Eric Anholt <eric@anholt.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH 5/6] drm/i915: Fix lock order reversal with cliprects
 and cmdbuf in non-DRI2 paths.
Message-ID: <20090326175230.65f10581@hobbes>
In-Reply-To: <1238017510-26784-6-git-send-email-eric@anholt.net>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
	<1238017510-26784-2-git-send-email-eric@anholt.net>
	<1238017510-26784-3-git-send-email-eric@anholt.net>
	<1238017510-26784-4-git-send-email-eric@anholt.net>
	<1238017510-26784-5-git-send-email-eric@anholt.net>
	<1238017510-26784-6-git-send-email-eric@anholt.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009 14:45:09 -0700
Eric Anholt <eric@anholt.net> wrote:

> This introduces allocation in the batch submission path that wasn't
> there previously, but these are compatibility paths so we care about
> simplicity more than performance.
> 
> kernel.org bug #12419.

Don't care too much here as long as it's been tested.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
