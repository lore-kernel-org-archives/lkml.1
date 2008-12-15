Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbYLOWoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbYLOWoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 17:44:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbYLOWnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 17:43:55 -0500
Received: from usul.saidi.cx ([204.11.33.34]:60503 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751443AbYLOWnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 17:43:55 -0500
To: "Robert M. Albrecht" <mail@romal.de>
Subject: Re: Bug 10173 / Bluetooth on Toshiba & Compal laptops
MIME-Version: 1.0
Date: Mon, 15 Dec 2008 17:47:25 -0500
From: Philip Langdale <philipl@overt.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4946DB8C.5000308@romal.de>
References: <4946BE11.5080501@romal.de> <bbd413efc08484efe55c558e9a0980fb@localhost> <4946DB8C.5000308@romal.de>
Message-ID: <5a670e0fe13a5f433ef207efefd71ca2@localhost>
User-Agent: RoundCube Webmail/0.2-beta
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 15 Dec 2008 23:34:52 +0100, "Robert M. Albrecht" <mail@romal.de>
wrote:
> Hi Phil,
> 
> anything I can do ? Providing some logs or granting ssh access to the 
> machine to have a look ?

If necessary, that would be useful. However, the first question to ask is
actually
related to my possibility C) - which I'm now re-evaluating as much more
likely.

If you don't load the 'rfkill-input' module, then there is no policy
applied to
killswitch handling. The core driver puts the device in the SOFT_BLOCKED
state
when the de-assert the hardware switch. rfkill-input contains the policy
that
decides to go one step further and re-enable the device. This module has no
hardware dependencies so it is not automatically loaded - you must do it
explicitly yourself.

If that's not your problem, then we'll have to dig deeper.

--phil
