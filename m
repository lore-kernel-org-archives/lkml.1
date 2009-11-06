Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbZKFIQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbZKFIQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 03:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbZKFIQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 03:16:43 -0500
Received: from smtprelay06.ispgateway.de ([80.67.31.29]:56490 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651AbZKFIQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 03:16:42 -0500
Message-ID: <4AF3DB6C.2070300@ladisch.de>
Date: Fri, 06 Nov 2009 09:16:44 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrea Righi <righi.andrea@gmail.com>
Subject: Re: [PATCH] fbcon: make cursor display conditional
References: <1257412658-9444-1-git-send-email-daniel@caiaq.de>
In-Reply-To: <1257412658-9444-1-git-send-email-daniel@caiaq.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack wrote:
> For embedded systems, the blinking cursor at startup time can be
> annoying and unintended. Add a new kernel parameter
> 'fbcon_disable_cursor' which disables it conditionally.

Wouldn't it be more useful to change the CUR_DEFAULT symbol (see the
end of <linux/console_struct.h>) into a kernel parameter, instead of
adding a new flag?


Best regards,
Clemens


