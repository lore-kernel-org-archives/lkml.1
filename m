Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbZLCW6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbZLCW6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbZLCW6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:58:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753111AbZLCW6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:58:09 -0500
Date: Thu, 3 Dec 2009 14:57:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pat Gefre <pfg@sgi.com>
Subject: Re: [PATCH 2/2] IOC3/IOC4: Fix error path on driver registration
Message-Id: <20091203145744.f1668cc7.akpm@linux-foundation.org>
In-Reply-To: <20091203143939.099aa431@hyperion.delvare>
References: <20091203143939.099aa431@hyperion.delvare>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Dec 2009 14:39:39 +0100
Jean Delvare <khali@linux-fr.org> wrote:

> Note: I was not able to build-test these patches, please do.

I tried, but it seems that they're finally managed to kill my ia64
toolchain:

/usr/src/25/arch/ia64/include/asm/paravirt_privop.h:409: error: impossible constraint in `asm'

oh well.  If it doesn't compile I'm sure that someone will let us know.


