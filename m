Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193Ab0AGQC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab0AGQC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 11:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692Ab0AGQCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 11:02:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58274 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab0AGQCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 11:02:54 -0500
Date: Thu, 7 Jan 2010 17:02:46 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [bisected] sys_paccept: disable paccept() causes my macbook
	pro to  have an annoying whining sound
Message-ID: <20100107160246.GB16076@basil.fritz.box>
References: <dd18b0c31001062216m316163f4t992c000eca0f76d@mail.gmail.com> <873a2ixmwy.fsf@basil.nowhere.org> <4B460132.3010706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B460132.3010706@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As for the power management
> I didn't think so.. sounds more
> like vibration of a solder joint/capacitor

Typically those are caused by power management -- cpu going in/out 
sleep states.

You can check by e.g. limiting your CPU to C1 with 
processor.max_cstate=1

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
