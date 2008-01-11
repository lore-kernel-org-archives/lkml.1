Return-Path: <linux-kernel-owner+w=401wt.eu-S1762314AbYAKRyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762314AbYAKRyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 12:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761521AbYAKRyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 12:54:12 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:49299 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760948AbYAKRyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 12:54:11 -0500
Date: Fri, 11 Jan 2008 18:54:05 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: v4l-dvb-maintainer@linuxtv.org, akpm <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dvb/av7110: fix section mismatch
Message-ID: <20080111175405.GB28624@uranus.ravnborg.org>
References: <20080110143147.26a1ce88.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110143147.26a1ce88.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 02:31:47PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix driver data name to match whitelist of acceptable names that contain
> pointers init data so that section mismatch warning is placated.
> 
> WARNING: vmlinux.o(.data+0x141288): Section mismatch: reference to .init.text:av7110_attach (between 'av7110_extension' and 'ir_protocol')
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

