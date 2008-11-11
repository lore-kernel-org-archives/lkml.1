Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbYKKWmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbYKKWmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:42:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYKKWlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:41:55 -0500
Received: from styx.suse.cz ([82.119.242.94]:42230 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750984AbYKKWlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:41:55 -0500
Date: Tue, 11 Nov 2008 23:41:54 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use single threaded work queue for hid_compat
In-Reply-To: <20081110215150.GA8460@basil.nowhere.org>
Message-ID: <alpine.LNX.1.10.0811112341350.24889@jikos.suse.cz>
References: <20081110215150.GA8460@basil.nowhere.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008, Andi Kleen wrote:

> I doubt HID really needs to scale over multiple CPUs. So only use a 
> single threaded workqueue for HID_COMPAT. This avoids some excessive 
> thread use on systems with a larger number of CPUs.

Yes, makes sense, thanks. Applied.

-- 
Jiri Kosina
SUSE Labs
