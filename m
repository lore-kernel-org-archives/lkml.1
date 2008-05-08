Return-Path: <linux-kernel-owner+w=401wt.eu-S1762278AbYEHXff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762278AbYEHXff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbYEHXfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:35:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753277AbYEHXfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:35:18 -0400
Date: Thu, 8 May 2008 16:34:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: djwong@us.ibm.com
Cc: mhoffman@lightlink.com, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH v3] ibmaem: New driver for power/energy/temp meters in
 IBM System X hardware
Message-Id: <20080508163443.a1e9ffe7.akpm@linux-foundation.org>
In-Reply-To: <20080508180858.GM16078@tree.beaverton.ibm.com>
References: <20080508180858.GM16078@tree.beaverton.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008 11:08:59 -0700
"Darrick J. Wong" <djwong@us.ibm.com> wrote:

> This driver reads IBM Active Energy Manager energy/temperature/power
> sensors on IBM System X hardware.

This driver is littered with 64-bit divides and doesn't link on i386.
I'll make it depend on CONFIG_64BIT for now.
