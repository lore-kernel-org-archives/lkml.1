Return-Path: <linux-kernel-owner+w=401wt.eu-S964910AbXIGA2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964910AbXIGA2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 20:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964783AbXIGA2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 20:28:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932658AbXIGA2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 20:28:40 -0400
Date: Thu, 6 Sep 2007 20:26:24 -0400
From: Bill Nottingham <notting@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add CONFIG_VT_UNICODE
Message-ID: <20070907002624.GA12631@nostromo.devel.redhat.com>
Mail-Followup-To: "H. Peter Anvin" <hpa@zytor.com>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	linux-kernel@vger.kernel.org
References: <20070831201820.GF31970@nostromo.devel.redhat.com> <46D9D587.9020605@zytor.com> <Pine.LNX.4.64.0709061404120.25942@fbirervta.pbzchgretzou.qr> <46E00962.7080903@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E00962.7080903@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin (hpa@zytor.com) said: 
> Hmmm...
>
> Personally I'd suggest making it the default unless overridden in 
> /etc/sysctl.conf.  My second preference would be a command-line option, not 
> a compile-time default.
>
> This is 2007, after all, and it seems Unicode should be the default, 
> anything else legacy...

At the moment, it's a module parameter (ergo sysfs), not /proc/sys.
Also, this patch ties unicode for the keyboard as well.

Bill
