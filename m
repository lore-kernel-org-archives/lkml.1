Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbYEWSq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbYEWSq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 14:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYEWSqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 14:46:16 -0400
Received: from westnet.com ([216.187.52.2]:53313 "EHLO westnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbYEWSqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 14:46:15 -0400
Date: Fri, 23 May 2008 14:46:13 -0400 (EDT)
From: Greg Smith <gsmith@gregsmith.com>
X-X-Sender: gsmith@westnet.com
To: Anton Petrusevich <casus@casus.us>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: PostgreSQL pgbench performance regression in 2.6.23+
In-Reply-To: <200805231326.44247.casus@casus.us>
Message-ID: <Pine.GSO.4.64.0805231418140.3708@westnet.com>
References: <200805231326.44247.casus@casus.us>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008, Anton Petrusevich wrote:

> Excuse me for interrupting you, but am I getting this right: to run
> effectively PostgreSQL with an active web app on the server a "system
> administrator Joe" has to know about batch scheduling?

That's not true.  The problem here is specifically with the pgbench 
program, which is a simple benchmarking tool included with PostgreSQL. 
pgbench already had known scalability problems due to its inefficient 
design and the new scheduler really doesn't play well with it by default. 
It's the pgbench program that needs the batch scheduling, not the database 
processes.

pgbench is certainly not representative of web application performance, 
and it wouldn't be the first time there was some OS tweaking required to 
get good results from such an artificial benchmark.

--
* Greg Smith gsmith@gregsmith.com http://www.gregsmith.com Baltimore, MD
