Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbYFCVCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbYFCVCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 17:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbYFCVBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 17:01:49 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:59502 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbYFCVBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 17:01:48 -0400
Date: Tue, 3 Jun 2008 17:00:48 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nix <nix@esperi.org.uk>, dhazelton@enter.net, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/6] UML - Deal with host time going backwards
Message-ID: <20080603210048.GA12182@c2.user-mode-linux.org>
References: <20080603190235.GA9511@c2.user-mode-linux.org> <20080603123211.e129c222.akpm@linux-foundation.org> <200806031543.56864.dhazelton@enter.net> <878wxmfg99.fsf@hades.wkstn.nix> <20080603130709.fcf6a751.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080603130709.fcf6a751.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 01:07:09PM -0700, Andrew Morton wrote:
> So if I change the host's time by an hour, the time will not advance at all
> on the guest for the next hour? Sounds suboptimal :)

It is, but if the host is whacked, the guest just has to do the best that
it can...

			Jeff

-- 
Work email - jdike at linux dot intel dot com
