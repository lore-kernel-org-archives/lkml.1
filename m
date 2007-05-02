Return-Path: <linux-kernel-owner+w=401wt.eu-S1767053AbXEBVld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767053AbXEBVld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767058AbXEBVld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:41:33 -0400
Received: from web88108.mail.re2.yahoo.com ([206.190.37.209]:42582 "HELO
	web88108.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1767053AbXEBVlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:41:32 -0400
X-YMail-OSG: y21L_G0VM1m6GgamVoQecQoE8oHH36ZwBUyr2w9Qm1t4d613jaSmkoRSyZNQV28Njhisj3cZiSKLb2JrAYPeBpeoVUOCFpuGPSlHME_IMksiRAmdMY8_
X-Mailer: YahooMailRC/478 YahooMailWebService/0.7.41.10
Date: Wed, 2 May 2007 14:41:30 -0700 (PDT)
From: Matt Ranon <mranon@javadevices.com>
Subject: [ANNOUNCE][PATCH] Kcfg - simple kernel configuration
To: linux maillist <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Message-ID: <589896.50284.qm@web88108.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Jem team is pleased to announce the release of Kcfg, an in-kernel simple 
configuration utility. Kcfg is intended for the same class of special embedded 
Linux applications as Kcli is, i.e., those applications with no user space. If 
you don't understand what kind of application that is, look at Jem itself 
at http://www.javadevices.com which is on schedule for release in August. 
Kcfg is the second spin-off from the Jem project.

Kcfg is a kernel loadable module that reads a configuration file of name/value 
pairs, and allows other kernel modules to query those values. Once a 
configuration file has been loaded by the module, other kernel modules can 
query the configuration values by name, set values, add new values, store 
the current values back to the configuration file and add callbacks to values 
in order to be informed when the values are modified.

To head off the obvious criticisms, be aware of the following:
1) We know about module parameters, but, when you have 20 configurable 
items, module parameters become impractical. Also, when you have no user 
space from which to load the module, parameters are even less practical.
2) We know about the other possibilities like sysfs, or the firmware mechanism, 
but we don't have a user space so that doesn't work for us either.

As always, and just like the GPL says, we don't claim that this code is fit for any 
purpose, nor do we claim that it is a better way of doing things. However, judging 
by the amount of downloads of Kcli,we think we were quite right in our assumption 
that people are doing some pretty weird things with the Linux kernel, and this 
code is for them.

Finally, don't even bother thinking about including this code in the mainline kernel, 
as it breaks some rules, like reading and writing files in a kernel module. We 
think the greatest fun of the Linux kernel, is you get to break all the rules.

The patch is available at: ftp://www.javadevices.com/kcfg

As a side note, updates to Kcli  have been posted at: ftp://www.javadevices.com/kcli 

MRanon
