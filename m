Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbYK1WmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbYK1WmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 17:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYK1WmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 17:42:01 -0500
Received: from rv-out-0506.google.com ([209.85.198.227]:47018 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbYK1WmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 17:42:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VRsrxo5zbG+SXdBPdj0NzwgIYQc+JV5plMhOdlLrLxc8yJnuRmzPawFtAFQuMPGxkp
         u/5KRTs401C6NZULB1VgcRjtmLfjutGkd7KGWEWlHu+q6LT+XcitBxdxlp3fCLJ18xh9
         yDEl+Gd/uiURflzHurU3H1TKIltN9R3ftBZ7k=
Message-ID: <19f34abd0811281441m6245d1bag2053619939270a5a@mail.gmail.com>
Date: Fri, 28 Nov 2008 23:41:59 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH] kbuild: fix CONFIG_EMBEDDED submenu
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081128173849.GA19101@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081128173849.GA19101@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2008 at 6:38 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> From 06f65799401f08eff0020ba0300133c89bd02349 Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Fri, 28 Nov 2008 18:29:47 +0100
> Subject: [PATCH] kbuild: fix CONFIG_EMBEDDED submenu
>
> Many of the elements of the EMBEDDED submenu were being expanded
> in the current menu instead of inside the submenu. This was caused
> by the lack of (explicit) dependencies on EMBEDDED. The simplest
> fix is to wrap everything (except COMPAT_BRK, which just toggles a
> setting) in "if/endif EMBEDDED".

Urgh -- the menu displays correctly, but defconfig now becomes totally
wrong, because the items inside are taken to depend on EMBEDDED
instead of toggling visibility. Better to add "if EMBEDDED" to the end
of all the prompts, then.

That was counter-intuitive :-(


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
