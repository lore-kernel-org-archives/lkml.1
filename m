Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbYA3NbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbYA3NbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbYA3NbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:31:08 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:50143 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbYA3NbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:31:07 -0500
Date: Wed, 30 Jan 2008 14:31:05 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Jonas Bonn <jonas@southpole.se>, netdev@vger.kernel.org,
       romieu@fr.zoreil.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [SIS190] Constify data marked as __devinitdata
In-Reply-To: <20080130112559.GA21346@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0801301429230.15249@fbirervta.pbzchgretzou.qr>
References: <1201690388-9052-1-git-send-email-jonas@southpole.se>
 <Pine.LNX.4.64.0801301220570.15249@fbirervta.pbzchgretzou.qr>
 <20080130112559.GA21346@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 30 2008 12:25, Sam Ravnborg wrote:
>
>We have just introduced __initconst, __cpuinitconst, __meminitconst
>for const data.
>So the patch is wrong.

Oh joy, more tags. Is it actually possible to combine const
with __devinitconst now?

static const uint16_t foo[] __devinitconst = { ... };
