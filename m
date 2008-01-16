Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbYAPPmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbYAPPmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 10:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbYAPPma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 10:42:30 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:28697
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751400AbYAPPma convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 10:42:30 -0500
Message-Id: <478E3411.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 16 Jan 2008 15:42:57 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@suse.de>
Cc: "Glauber de Oliveira Costa" <glommer@gmail.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0 of 4] x86: some more patches
References: <patchbomb.1200435425@localhost>
 <200801161544.15884.ak@suse.de> <20080116145427.GA640@elte.hu>
 <200801161626.01711.ak@suse.de>
In-Reply-To: <200801161626.01711.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Yes, but if you cast to long the result will be 32bit again. Or do you
>rely on it being always used in 64bit signed context with sign extension?
>While that might work it would seem rather fragile to me, just asking
>for similar future bugs.

Even if conversion is to 64-bit unsigned, the value (being signed) will be
sign-extended first (to preserve its value modulo 2**<target type width>).

Jan

