Return-Path: <linux-kernel-owner+w=401wt.eu-S1759261AbXKTKsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261AbXKTKsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 05:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbXKTKsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 05:48:47 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:49435
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754174AbXKTKsr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 05:48:47 -0500
Message-Id: <4742C9D7.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 20 Nov 2007 10:49:43 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Greg Kroah-Hartman" <GregKH@novell.com>, <gary.hade@us.ibm.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Avoid creating P2P prefetch window for expansion ROMs
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (in its incarnation in our SLE10SP2 tree) is causing resource
allocation failures on one of my machines. The condition for this is that
besides ROMs behind a bridge not having their base addresses assigned
there's no extra space available in the non-prefetch window to
accommodate the ROMs' space. I therefore think the change, while
having a good reason, isn't complete so far, as it would imply the need
for checking whether space in the non-prefetch window is sufficient and
continuing to force the creation of a prefetch window otherwise.

Jan

