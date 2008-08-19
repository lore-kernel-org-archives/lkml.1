Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbYHSJ7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbYHSJ7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYHSJ7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:59:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753110AbYHSJ7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:59:04 -0400
Date: Tue, 19 Aug 2008 02:58:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: corentincj@iksaif.net, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 2/2] eeepc-laptop: Use standard interfaces
Message-Id: <20080819025815.b5ec1a4c.akpm@linux-foundation.org>
In-Reply-To: <20080806092523.GB17801@srcf.ucam.org>
References: <20080804170833.GA9513@srcf.ucam.org>
	<20080806092352.GA17801@srcf.ucam.org>
	<20080806092523.GB17801@srcf.ucam.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008 10:25:23 +0100 Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> eeepc-laptop currently only sends key events via ACPI and has 
> non-standard rfkill control. Add an input device and use the rfkill 
> infrastructure.
>

drivers/misc/eeepc-laptop.c: In function 'eeepc_hotk_add':
drivers/misc/eeepc-laptop.c:577: error: 'CM_ASL_WIFI' undeclared (first use in this function)
drivers/misc/eeepc-laptop.c:577: error: (Each undeclared identifier is reported only once
drivers/misc/eeepc-laptop.c:577: error: for each function it appears in.)
drivers/misc/eeepc-laptop.c:595: error: 'eeepc_bluetooth_rfkill_set' undeclared (first use in this function)
drivers/misc/eeepc-laptop.c:597: error: 'eeepc_bluetooth_rfkill_state' undeclared (first use in this function)

maybe this had some dependencies which I didn't know about.

