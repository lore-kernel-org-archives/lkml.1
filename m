Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbYAJMdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbYAJMdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 07:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbYAJMdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 07:33:03 -0500
Received: from postfix1-g20.free.fr ([212.27.60.42]:42391 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbYAJMdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 07:33:00 -0500
Message-ID: <47860FA7.1090501@fnac.net>
Date: Thu, 10 Jan 2008 13:29:27 +0100
From: Paul Chavent <paul.chavent@fnac.net>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Usb generic serial.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello and happy new year 2008.

In drivers/usb/serial/usb-serial.c there is a function (fixup_generic / 
set_to_generic_if_null) that hooks null fops to the generic driver ones.

The drivers/usb/serial/generic.c implements throttle, unthrottle and 
resume, but those aren't used by default in fixup_generic. Is there any 
reasons ? Could we submit a patch for that ?

Thank you for your help.




