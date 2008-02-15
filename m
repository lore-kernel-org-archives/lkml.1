Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbYBOVTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbYBOVTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbYBOVTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:19:13 -0500
Received: from ishtar.tlinx.org ([64.81.245.74]:57552 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbYBOVTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:19:12 -0500
Message-ID: <47B601CF.9070300@tlinx.org>
Date: Fri, 15 Feb 2008 13:19:11 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: x86-32-config: why is pc-speaker an input device?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm wondering how the generic, builtin PC-Speaker (config option
"INPUT_PCSPKR") can be used as an input device.

If it can not be used for input, why is it under the input config section:

"Device Drivers"
+ -> "Input Device Support"
     + -> "Miscellaneous devices"
         + -> "PC Speaker Support"

When booting, it is "enumerated" as an input device: (from dmesg)

  input: PC Speaker as /devices/platform/pcspkr/input/input2

Just trying to figure out the rationale behind the choice...

