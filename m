Return-Path: <linux-kernel-owner+w=401wt.eu-S935719AbYBVBO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935719AbYBVBO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 20:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbYBVBOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 20:14:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47455 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbYBVBOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 20:14:49 -0500
Date: Thu, 21 Feb 2008 17:14:35 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: James Morris <jmorris@namei.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: Boot hang with stack protector on x86_64
Message-ID: <20080221171435.4b7a6497@laptopd505.fenrus.org>
In-Reply-To: <Xine.LNX.4.64.0802221121340.20800@us.intercode.com.au>
References: <Xine.LNX.4.64.0802221121340.20800@us.intercode.com.au>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2008 11:29:37 +1100 (EST)
James Morris <jmorris@namei.org> wrote:

> I've been getting an immediate hang on boot since:
> 
> e06b8b98da071f7dd78fb7822991694288047df0 kbuild: allow
> -fstack-protector to take effect
> 
> This is on an x86_64 system (actually an Intel SDV -- so it might be 
> "special").
> 
> My .config has the following:
> 
> CONFIG_CC_STACKPROTECTOR=y
> CONFIG_CC_STACKPROTECTOR_ALL=y
> 
> Let me know if you need more information.
> 
> 
Ingo has a set of stackprotector fixes that should go to mainline ASAP.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
