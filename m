Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbYAIMUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbYAIMUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 07:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbYAIMUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 07:20:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37902 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbYAIMUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 07:20:33 -0500
Date: Wed, 9 Jan 2008 12:20:28 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Nikanth Karthikesan <knikanth@suse.de>, grant@torque.net, tim@cyberelk.net,
       Christoph Hellwig <hch@infradead.org>, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Change paride driver to use unlocked_ioctl instead of
	ioctl
Message-ID: <20080109122027.GA13254@infradead.org>
References: <4785B7BC.5040106@suse.de> <20080109080620.GE32560@infradead.org> <1199955347.6203.6.camel@nikanth-laptop.blr.novell.com> <Pine.LNX.4.64.0801091313231.29244@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801091313231.29244@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 01:14:25PM +0100, Jan Engelhardt wrote:
> I wonder why a simple copy_from_user() requires the BKL.. if pt
> does need locking, then probably some mutex inside pt.

Given this is a janitorial project where the people don't even have
the hardware to test it's best to do a 1:1 conversion instead of making
it more complex.

