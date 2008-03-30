Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbYC3LhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbYC3LhR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 07:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbYC3LhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 07:37:06 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:43993 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbYC3LhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 07:37:05 -0400
Date: Sun, 30 Mar 2008 15:36:57 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: David Fries <david@fries.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/35] W1: w1_io.c reset comments and msleep
Message-ID: <20080330113655.GK15122@2ka.mipt.ru>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net> <20080328122655.GV3613@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328122655.GV3613@spacedout.fries.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 07:26:55AM -0500, David Fries (david@fries.net) wrote:
> w1_io.c 1.7
> w1_reset_bus, added some comments about the timing and switched to
> msleep for the later delay.  I don't have the hardware to test the
> sleep after reset change.  The one wire doesn't have a timing                   requirement between commands so it is fine.  I do have the USB                  hardware and it would be in big trouble with 10ms interrupt transfers
> to find that the reset completed.

Ack.


-- 
	Evgeniy Polyakov
