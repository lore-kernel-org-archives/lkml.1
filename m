Return-Path: <linux-kernel-owner+w=401wt.eu-S1752882AbYIAXaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbYIAXaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbYIAXaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:30:08 -0400
Received: from twin.jikos.cz ([213.151.79.26]:44534 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbYIAXaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:30:07 -0400
Date: Tue, 2 Sep 2008 01:29:59 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Daniel Barkalow <barkalow@iabervon.org>
cc: linux-kernel@vger.kernel.org,
       Christopher Desjardins <cddesjardins@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: Lenovo 3000 N100 i8042 problems
In-Reply-To: <alpine.LNX.1.00.0808240148580.19665@iabervon.org>
Message-ID: <Pine.LNX.4.64.0809020120130.29111@twin.jikos.cz>
References: <alpine.LNX.1.00.0808240148580.19665@iabervon.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008, Daniel Barkalow wrote:

> In 2.6.25.10, I'm finding that my i8042 seems to die after a while. In the 
> middle of using the keyboard and mouse, generally before some key release 
> is handled, it stops taking any input.
> This seems to be due to 2a2dcd65e232eafd9fb6da1250f83adb57787b42; it works 
> fine with that reverted. Perhaps that quirk is being applied too widely? 

Hi Daniel,

thanks for tracking down the commit. Also, please don't forget to CC the 
commit author in such cases :)

Could you please send a dmidecode output from your system, so that we can 
compare it to the one provided by Christopher, as he as the system that 
apparently needs the nomux quirk to work correctly? It's indeed possible 
that there are various systems out there, and the DMI match has to be made 
more strict.

Thanks,

-- 
Jiri Kosina
SUSE Labs

