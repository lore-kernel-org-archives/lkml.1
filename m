Return-Path: <linux-kernel-owner+w=401wt.eu-S934005AbZLJL0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934005AbZLJL0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 06:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933773AbZLJL0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 06:26:46 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:53233 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933737AbZLJL0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 06:26:45 -0500
Message-ID: <4B20DB2C.5040404@xenontk.org>
Date: Thu, 10 Dec 2009 16:57:40 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.4pre) Gecko/20091014 Thunderbird/3.0b4
MIME-Version: 1.0
To: chris@chris-wilson.co.uk
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, eric@anholt.net,
       airlied@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       hohndel@infradead.org
Subject: Re: [Regression 2] i915: Commit 0d9c778978 causes flickering in 2.6.32
References: <4B1FDAE3.9050602@xenontk.org>
In-Reply-To: <4B1FDAE3.9050602@xenontk.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2009 10:44 PM, David John wrote:
> Hi All,
> 
> I have a Dell Inspiron with a GM45 Express chipset and an Acer 23"
> display connected to the VGA out. I switch off the internal LVDS LCD
> on X start-up with xrandr. X works fine but if I switch to a console,
> it flickers horribly with the text all pushed to the right. Switching
> back to X causes X to start flickering as well. Turning the internal
> LVDS back _on_ solves the issue. It works like a switch so it is easily
> reproducible. Reverting commit 0e442c60 also fixes the problem.
> 
> There isn't anything unusual in the kernel or X logs that I could see,
> but they're attached.
> 
> Regards,
> David.

Hi,

Reverting the above commit fixes 95% of the problem, the console no
longer flickers. However, the same sequence: Switch off LVDS->
Switch to console->Switch back to X causes slight flicker in X with
the commit 0d9c778978. Turning the internal LVDS back on solves the
issue. Reverting commit 0d9c778978 fixes the problem completely (Both
commits have to be reverted).

Regards,
David.

