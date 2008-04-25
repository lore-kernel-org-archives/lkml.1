Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbYDYEoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbYDYEoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 00:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYDYEoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 00:44:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:55100 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbYDYEoX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 00:44:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,706,1199692800"; 
   d="scan'208";a="556904236"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 24/24] Use U64_C() instead of casts in kernel/time.c
Date: Thu, 24 Apr 2008 21:44:17 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843EC012FA04B@orsmsx424.amr.corp.intel.com>
In-Reply-To: <200804250410.m3P4A67w019427@tazenda.hos.anvin.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 24/24] Use U64_C() instead of casts in kernel/time.c
Thread-Index: AcimikDAt8BjvhaKQy+gHi+weYTr3wABEo0w
References: <1209078352-7593-1-git-send-email-hpa@zytor.com><1209078352-7593-2-git-send-email-hpa@zytor.com><1209078352-7593-3-git-send-email-hpa@zytor.com><1209078352-7593-4-git-send-email-hpa@zytor.com><1209078352-7593-5-git-send-email-hpa@zytor.com><1209078352-7593-6-git-send-email-hpa@zytor.com><1209078352-7593-7-git-send-email-hpa@zytor.com><1209078352-7593-8-git-send-email-hpa@zytor.com><1209078352-7593-9-git-send-email-hpa@zytor.com><1209078352-7593-10-git-send-email-hpa@zytor.com><1209078352-7593-11-git-send-email-hpa@zytor.com><1209078352-7593-12-git-send-email-hpa@zytor.com><1209078352-7593-13-git-send-email-hpa@zytor.com><1209078352-7593-14-git-send-email-hpa@zytor.com><1209078352-7593-15-git-send-email-hpa@zytor.com><1209078352-7593-16-git-send-email-hpa@zytor.com><1209078352-7593-17-git-send-email-hpa@zytor.com><1209078352-7593-18-git-send-email-hpa@zytor.com><1FE6DD409037234FAB833C420AA843EC012F9FDA@orsmsx424.amr.corp.intel.com> <200804250410.m3P4A67w019427@tazenda.hos.
	anvin.org>
From: "Luck, Tony" <tony.luck@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Arch Mailing List" <linux-arch@vger.kernel.org>
X-OriginalArrivalTime: 25 Apr 2008 04:44:21.0937 (UTC) FILETIME=[07ACFA10:01C8A68F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Note that since pasting has priority over macro resolution, the header
> file generation is modified to have suffixed versions of all the
> generated values.

Much better.  Builds and boots on ia64 now.  I only ran some trivial
tests, but it still seems to be counting time correctly.

Acked-by: Tony Luck <tony.luck@intel.com>
