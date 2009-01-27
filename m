Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbZA0HA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbZA0HA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 02:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZA0HAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 02:00:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751703AbZA0HAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 02:00:14 -0500
Date: Mon, 26 Jan 2009 22:59:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, rydberg@bitmath.org,
       torvalds@linux-foundation.org, mjg@redhat.com, nicolas@boichat.ch,
       rydberg@euromail.se, linux-kernel@vger.kernel.org
Subject: Re: [patch 18/19] Define MODULE_SYSTEM_TABLE for mbp_nvidia_bl.o
 and applesmc.o
Message-Id: <20090126225909.0937356c.akpm@linux-foundation.org>
In-Reply-To: <20081212042503.GA14668@x200.localdomain>
References: <200812092114.mB9LETsI027215@imap1.linux-foundation.org>
	<493F1C96.5070400@bitmath.org>
	<200812120305.mBC35vh8078366@www262.sakura.ne.jp>
	<20081212042503.GA14668@x200.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2008 07:25:03 +0300 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> > -MODULE_DEVICE_TABLE(dmi, applesmc_whitelist);
> > +MODULE_SYSTEM_TABLE(dmi, applesmc_whitelist);
> 
> I sent patch which does "#define dmi_device_id dmi_system_id" and thus
> avoids yet another wrapper.

What was the fate of this patch?

If it's still needed, please resend.
