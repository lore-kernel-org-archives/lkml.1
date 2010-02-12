Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab0BLKmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 05:42:43 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:54784 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab0BLKmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 05:42:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=T1ZZDEqK5EDPsEARIH5vmlhKa1Tb+MtQSdoAuYxdeiHR0niA8mUldgr/O3W3Ubo+ig
         Vm1X5QRRNcGHX3tnUg+8x6oGYdIk9OlUgkzVKg5dO7XpOOsOf+kSDg/vijR+KOFe7uGx
         Q73FGQ9W64K5/9KRPzqF3bAyCfHOP/ELzFg08=
Subject: [WARNING] mxc_w1_probe should not be __init modified
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Feb 2010 11:42:28 +0100
Message-ID: <1265971348.2484.63.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today linux-next build, report this:

WARNING: drivers/w1/masters/built-in.o(.data+0x0): Section mismatch in reference from the variable mxc_w1_driver to the function .init.text:mxc_w1_probe()
The variable mxc_w1_driver references
the function __init mxc_w1_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 


I don't know if should be modified with __devinit instead or nothing at all.

Best regards.

-- 
Alberto!


