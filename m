Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYAXL4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYAXL4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 06:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYAXL42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 06:56:28 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:16014
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752237AbYAXL41 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 06:56:27 -0500
Message-Id: <47988B1F.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 24 Jan 2008 11:57:03 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: "Roman Zippel" <zippel@linux-m68k.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tristate choices with mixed tristate and boolean
	values (v2)
References: <47977D08.76E4.0078.0@novell.com>
 <20080123171719.GB22967@uranus.ravnborg.org>
In-Reply-To: <20080123171719.GB22967@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>menu_finalize as it stand today is already too complicated.
>
>Could we have this additional functionlity factored out or at least commented
>so mare humans have a small chance to understand what is going on.

I'd prefer leaving the factoring-out to Roman, in fear of breaking
something if I do it myself. I sent out an updated patch just a second
ago, which adds a comment as you requested and also fixes another
problem (not one the patch introduced) that utilizing the new
functionality elsewhere uncovered.

Jan

