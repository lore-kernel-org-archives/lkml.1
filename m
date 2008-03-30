Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbYC3Lak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbYC3Lak (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 07:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbYC3Lad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 07:30:33 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:38476 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbYC3Lad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 07:30:33 -0400
Date: Sun, 30 Mar 2008 15:30:03 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: David Fries <david@fries.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/35] W1: feature, w1_therm.c use strong pullup
Message-ID: <20080330113003.GD15122@2ka.mipt.ru>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net> <20080328122510.GI3613@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328122510.GI3613@spacedout.fries.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 07:25:10AM -0500, David Fries (david@fries.net) wrote:
> w1_therm.c 1.3 1.4 1.10
> Use the strong pullup not the sleep.  Note that the pullup goes before
> W1_CONVERT_TEMP not after.
> +w1_next_pullup(dev, tm);
>  w1_write_8(dev, W1_CONVERT_TEMP);
> -msleep(tm);

I'm ok with it, but believe it has to be turned off by default and be
able to be turned on by parameter.

Did you test it with multiple devices on the same bus?

-- 
	Evgeniy Polyakov
