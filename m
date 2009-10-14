Return-Path: <linux-kernel-owner+w=401wt.eu-S934219AbZJNPO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934219AbZJNPO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761798AbZJNPOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:14:25 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:51068 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761507AbZJNPOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:14:25 -0400
Date: Wed, 14 Oct 2009 11:06:04 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, mingo@redhat.com,
       tglx@linutronix.de, akpm@linux-foundation.org, rostedt@goodmis.org,
       hpa@zytor.com, cebbert@redhat.com, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 01/16] vmalloc: fix use of non-existent percpu variable
 in put_cpu_var()
In-Reply-To: <1255500125-3210-2-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.1.10.0910141105360.26476@gentwo.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org> <1255500125-3210-2-git-send-email-tj@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks like a candidate for 2.6.32.


