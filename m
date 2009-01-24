Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbZAXLvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbZAXLvd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 06:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZAXLvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 06:51:23 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:3921 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbZAXLvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 06:51:23 -0500
Date: Sat, 24 Jan 2009 12:51:20 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Eric Anholt <eric@anholt.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Set up an MTRR covering the GTT at driver load.
Message-ID: <20090124115120.GA75534@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
References: <1232751258-32611-1-git-send-email-eric@anholt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232751258-32611-1-git-send-email-eric@anholt.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 02:54:17PM -0800, Eric Anholt wrote:
> +	/* Set up a WC MTRR for non-PAT systems.  This is more common than
> +	 * one would think, because the kernel disables PAT on first
> +	 * generation Core chips because WC PAT gets overridden by a UC
> +	 * MTRR if present.  Even if a UC MTRR isn't present.

As a non-native speaker, I don't understand what the last sentence
means.  X gets overridden by Y even if there's no Y doesn't make
sense.  Could you do a simpler version?

  OG.
