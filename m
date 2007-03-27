Return-Path: <linux-kernel-owner+w=401wt.eu-S1753049AbXC0DjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbXC0DjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 23:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbXC0DjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 23:39:10 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:33816 "EHLO
	asav05.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbXC0DjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 23:39:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CALIuCEZKhRO4dGdsb2JhbACPbAE
From: Dmitry Torokhov <dtor@insightbb.com>
To: =?utf-8?q?=C3=89ric_Piel?= <Eric.Piel@tremplin-utc.net>
Subject: Re: [PATCH 0/3] wistron_btns: More keymaps, take 2
Date: Mon, 26 Mar 2007 23:39:03 -0400
User-Agent: KMail/1.9.3
Cc: Vojtech Pavlik <vojtech@suse.cz>, mitr@volny.cz, otauber@web.de,
       linux-kernel@vger.kernel.org,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>
References: <45ECA23A.5010503@tremplin-utc.net> <45F91F73.8040200@tremplin-utc.net> <45FDAAB2.8010208@tremplin-utc.net>
In-Reply-To: <45FDAAB2.8010208@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703262339.04480.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 March 2007 17:10, Éric Piel wrote:
> Hello,
> 
> This is a new version of my patch to add support for more laptops to the 
> wistron_btns driver. Modifications from the previous version:
> * sends lid close/open event as a switch event (not a key event)
> * Display on/off is KEY_SCREEN and Display selection is 
> KEY_SWITCHVIDEOMODE, from the discussion they seemed the "less bad" 
> keycodes.
> * keymaps are now declared initdata in order to save some memory
>

Everyting applied to the input tree. Used new KEY_DISPLAYTOGGLE instead
of KEY_SCREEN.
 
Thank you Eric.

-- 
Dmitry
