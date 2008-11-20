Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbYKTTWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbYKTTWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbYKTTWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:22:37 -0500
Received: from igw3.watson.ibm.com ([129.34.20.18]:38086 "EHLO
	igw3.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbYKTTWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:22:37 -0500
Subject: Re: [PATCH 2/4] integrity: Linux Integrity Module(LIM)
From: david safford <safford@watson.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@liux-foundation.org>,
       James Morris <jmorris@namei.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20081120174506.GA20972@infradead.org>
References: <cover.1227137423.git.zohar@linux.vnet.ibm.com>
	 <ece5bb6863d9b42016860f3ef78656e4a228ad95.1227137423.git.zohar@linux.vnet.ibm.com>
	 <20081120174506.GA20972@infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 20 Nov 2008 14:21:38 -0500
Message-Id: <1227208898.3066.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-20 at 12:45 -0500, Christoph Hellwig wrote:
> Ok, the API looks sane to me.  But one big question:  any reason you
> don't just directly call into your implementation instead of all these
> odd hooks?  This seems to be a lot of overhead just for making the code
> less readable..
> 

The consensus in the (insane) security community was to have an
interface with selectable modules similar to LSM and its modules,
so that users could easily choose among a set of integrity providers.

dave
