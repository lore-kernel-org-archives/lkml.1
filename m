Return-Path: <linux-kernel-owner+w=401wt.eu-S1759431AbZCSI5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431AbZCSI5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 04:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757876AbZCSI4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 04:56:37 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42284 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390AbZCSI4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 04:56:36 -0400
Date: Thu, 19 Mar 2009 14:26:28 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: Question about usage of RCU in the input layer
Message-ID: <20090319085628.GA6167@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20090318215812.15496a86@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090318215812.15496a86@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 09:58:12PM -0700, Arjan van de Ven wrote:
> Hi,
> 
> the input layer does a "synchronize_rcu()" after a list_add_tail_rcu(), which
> is costing me 1 second of boot time.....
> And based on my understanding of the RCU concept, you only need to synchronize on delete,
> not on addition... so I think the synchronize is entirely redundant here...
> 

The more appropriate question is - why is synchronize_rcu() taking
1 second ? Any idea what the other CPUs are doing at the time
of calling synchronize_rcu() ? What driver is this ? How early
in the boot is this happening ? 

Thanks
Dipankar
