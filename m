Return-Path: <linux-kernel-owner+w=401wt.eu-S1756558AbZFDQj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbZFDQj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbZFDQjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:39:17 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:36512 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753298AbZFDQjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:39:15 -0400
Date: Thu, 4 Jun 2009 12:38:44 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Yinghai Lu <yinghai@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, mel@csn.ul.ie,
       suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, rusty@rustcorp.com.au, steiner@sgi.com,
       rientjes@google.com
Subject: Re: [RESEND PATCH] mm: clear N_HIGH_MEMORY map before se set it
 again -v2
In-Reply-To: <4A2758CB.9090404@kernel.org>
Message-ID: <alpine.DEB.1.10.0906041236520.5377@gentwo.org>
References: <4A05269D.8000701@kernel.org> <20090512111623.GG25923@csn.ul.ie> <4A0A64FB.4080504@kernel.org> <20090513145950.GB28097@csn.ul.ie> <4A0C4910.7090508@kernel.org> <4A0C4A2A.6080009@kernel.org> <20090514095414.ba8356e5.akpm@linux-foundation.org>
 <4A0C4F67.5080802@kernel.org> <20090514102554.b3a36f19.akpm@linux-foundation.org> <4A0C563A.3020100@kernel.org> <4A2758CB.9090404@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok. The N_HIGH_MEMORY bit is set for all onlines nodes in a loop
that follows the code you modified. The patch insures that bits do not
remain set that earlier arch / core code may have set.

Could you make the description clearer?

Otherwise

Acked-by: Christoph Lameter <cl@linux-foundation.org>

