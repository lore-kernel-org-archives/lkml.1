Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab0BIMlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 07:41:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:45875 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361Ab0BIMlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 07:41:01 -0500
Date: Tue, 9 Feb 2010 13:40:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ed Tomlinson <edt@aei.ca>
Cc: Bastien Nocera <hadess@hadess.net>,
       Justin Mattock <justinmattock@gmail.com>,
       Marcel Holtmann <marcel@holtmann.org>,
       Michael Poole <mdpoole@troilus.org>, "Gunn, Brian" <bgunn@solekai.com>,
       Ping <pinglinux@gmail.com>, linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
Subject: Re: [PATCH] Bluetooth: Keep a copy of each HID device's report
 descriptor.
In-Reply-To: <201002090736.55576.edt@aei.ca>
Message-ID: <alpine.LNX.2.00.1002091339190.30967@pobox.suse.cz>
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz> <dd18b0c31002082322m4238a4a6m73fc30752ba30447@mail.gmail.com> <1265710460.2383.5685.camel@localhost.localdomain> <201002090736.55576.edt@aei.ca>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Feb 2010, Ed Tomlinson wrote:

> What I am looking for is the patches to the kernel that add the new 
> function to bluetooth allowing the extra probing.  eg the patches (or 
> tree based on .32) that addthe initial version of 
> "hidp_output_raw_report" and friends.

It's commit 2da31939a4 (and fix 6bf8268f9a9 on top of that). You need 
quite recent 2.6.33-rc snapshot to have them both:

	$ git describe --contains 6bf8268f9a9
	v2.6.33-rc7~20^2~3^2

Plus there is additional patch queued in my tree, which allows user to 
specify type of the report that is to be sent (feature/output).

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
