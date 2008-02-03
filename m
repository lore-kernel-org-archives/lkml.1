Return-Path: <linux-kernel-owner+w=401wt.eu-S934198AbYBCMWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934198AbYBCMWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 07:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762580AbYBCMWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 07:22:36 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:60981 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762101AbYBCMWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 07:22:35 -0500
Date: Sun, 3 Feb 2008 13:22:39 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, bryan.wu@analog.com,
       hskinnemoen@atmel.co, dhowells@redhat.com
Subject: Re: [patch 0/4] cleanup - use _AC macro to define PAGE_SIZE
Message-ID: <20080203122239.GF20810@uranus.ravnborg.org>
References: <47a5a65d.03eb300a.07b8.130e@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47a5a65d.03eb300a.07b8.130e@mx.google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 02:22:17PM +0300, Cyrill Gorcunov wrote:
> This patch series removes code duplication for PAGE_SIZE
> definition on various architectures.
> 
> Please review. Any comments are welcome. *UNTESTED*

Looks good.
Could you do a followup patch for each architecture introducing
use of PAGE_SIZE in their respective kernel/vmlinux.lds.S too?
I think more than your 4 listed architectures could need this fix.

	Sam
