Return-Path: <linux-kernel-owner+w=401wt.eu-S936693AbYBWIeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936693AbYBWIeT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936932AbYBWIU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:20:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:46701 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936288AbYBWIUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:20:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=jCMrR0mIqYix+9/2O6/IPQeohFLex1md2jfpWHzrWxtRz9a/yTlCLoLQiv/qlTlfYNs4tCDFUk44qk3b+TK8taPRdCXYsSf/97SdHb9cfWLLV+3xuDSTZt8G1c9ophWjzdf8vgLbvVOmfaAu3pOz50Ps794e9DH1DVuXdL92BMo=
Date: Sat, 23 Feb 2008 11:20:27 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [Q] x86 - boot/header.S
Message-ID: <20080223082026.GA6747@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter, Sam,

could you take a look on x86/boot/header.S:280 please?

# Zero the bss
	movw	$__bss_start, %di
	movw	$_end+3, %cx
	xorl	%eax, %eax
	subw	%di, %cx
	shrw	$2, %cx
	rep; stosl

I wonder why is $_end there instead of $__bss_stop?
Well, accroding to vmlinux_32.lsd both _end and __bss_stop
are the same BUT __bss_stop is more convenient methink.
Would it be usefull to change?

		- Cyrill -
