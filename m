Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbZKFOjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbZKFOjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 09:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756983AbZKFOjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 09:39:17 -0500
Received: from trinity.develer.com ([83.149.158.210]:42636 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbZKFOjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 09:39:16 -0500
Date: Fri, 6 Nov 2009 15:39:18 +0100
From: Andrea Righi <righi.andrea@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] fbcon: make cursor display conditional
Message-ID: <20091106143916.GA30819@linux>
References: <1257412658-9444-1-git-send-email-daniel@caiaq.de>
 <4AF3DB6C.2070300@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF3DB6C.2070300@ladisch.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 06, 2009 at 09:16:44AM +0100, Clemens Ladisch wrote:
> Daniel Mack wrote:
> > For embedded systems, the blinking cursor at startup time can be
> > annoying and unintended. Add a new kernel parameter
> > 'fbcon_disable_cursor' which disables it conditionally.
> 
> Wouldn't it be more useful to change the CUR_DEFAULT symbol (see the
> end of <linux/console_struct.h>) into a kernel parameter, instead of
> adding a new flag?

Agreed. There's no need to choose if we want the blinking cursor or not
at each boot. Better to make this decision at compile time.

-Andrea
