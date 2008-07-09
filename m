Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbYGIOZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbYGIOZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 10:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbYGIOZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 10:25:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752890AbYGIOZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 10:25:02 -0400
Message-ID: <4874CA2A.3050600@linux-foundation.org>
Date: Wed, 09 Jul 2008 09:24:42 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Bruno Santos <bsantos@av.it.pt>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: semaphore: lockless fastpath using atomic_{inc,dec}_return
References: <4874B979.4020608@av.it.pt> <20080709071635.5c5ecc0f@infradead.org>
In-Reply-To: <20080709071635.5c5ecc0f@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And is this safe? It seems that we can always be rescheduled after the atomic operation and
interrupts can occur too. You need to tell us why this is safe in all cases.

