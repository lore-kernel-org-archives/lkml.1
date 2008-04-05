Return-Path: <linux-kernel-owner+w=401wt.eu-S1751742AbYDEGvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbYDEGvo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 02:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbYDEGve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 02:51:34 -0400
Received: from nn7.de ([85.214.94.156]:56024 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbYDEGvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 02:51:33 -0400
Subject: Re: 2.6.25 intended change: smc:kbd_backlight vs.
	smc::kbd_backlight ?
From: Soeren Sonnenburg <kernel@nn7.de>
To: Justin Mattock <justinmattock@gmail.com>
Cc: rpurdie@rpsys.net, Julien BLACHE <jb@jblache.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Rafael J\. Wysocki" <rjw@sisk.pl>
In-Reply-To: <dd18b0c30804042344we0e62a0s8cd2c7e8137a9e8@mail.gmail.com>
References: <1207162690.9669.11.camel@localhost>
	 <1207292068.4511.10.camel@localhost>
	 <dd18b0c30804040812x76f99af7o99fa57c9a1ec10bc@mail.gmail.com>
	 <1207373556.10237.2.camel@localhost>
	 <dd18b0c30804042344we0e62a0s8cd2c7e8137a9e8@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 05 Apr 2008 08:51:30 +0200
Message-Id: <1207378290.10237.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-04-05 at 06:44 +0000, Justin Mattock wrote:
> Hello; there must be some kind of reason for the change from ":" to
> "::" smc::kbd_backlight, maybee something with the kernel spitting
> out:
> 
> [  464.524630] applesmc: wait status failed: 5 != 4
[...]

> I'm tired of seeing this, how to get rid of this regression if you
> want to call this that.?
> regards;

The '::' is only a cosmetic thing and won't give you these messages.
Anyway I am getting them too (but very very rarely) - but it is a
completely different issue.

Soeren
