Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbZAFEZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbZAFEZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 23:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZAFEZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 23:25:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750906AbZAFEZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 23:25:32 -0500
Date: Mon, 5 Jan 2009 20:25:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/6] fastboot: Asynchronous function calls to speed up
 kernel boot
Message-Id: <20090105202514.399da36e.akpm@linux-foundation.org>
In-Reply-To: <20090105201041.3289d3dd@infradead.org>
References: <20090105200959.04a626ac@infradead.org>
	<20090105201041.3289d3dd@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009 20:10:41 -0800 Arjan van de Ven <arjan@infradead.org> wrote:

>  kernel/async.c         |  307 ++++++++++++++++++++++++++++++++++++++++++++++++

Am still wondering if this is unacceptably duplicative of dhowells's
slow-work infrastructure: http://lkml.org/lkml/2008/11/20/193


