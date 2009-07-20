Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbZGTToV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbZGTToV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 15:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbZGTToV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 15:44:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38021 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbZGTToU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 15:44:20 -0400
Date: Mon, 20 Jul 2009 21:44:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Doug Thompson <norsk5@yahoo.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
       Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, aris@redhat.com, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH 07/14] mce3: pass mce info to EDAC for decoding II
Message-ID: <20090720194419.GD16072@basil.fritz.box>
References: <20090720180446.GB16072@basil.fritz.box> <935428.51568.qm@web50110.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <935428.51568.qm@web50110.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 11:27:12AM -0700, Doug Thompson wrote:

Forgot to mention that problem earlier.

> On an Intel CPU based system, the AMD EDAC module wouldn't load due the missing AMD PCI Vendor/Device ID values during the module probe phase.

The problem is that the weak linking mechanism doesn't know anything
if the rest of the code initialised or not. So as soon as the amd
driver is built in it would be called unconditionally, and
in fact likely crash.

As far as I can see this whole thing barely works even on AMD
due to the other problems.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
