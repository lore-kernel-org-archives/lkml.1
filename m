Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbZCTGBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbZCTGBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 02:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbZCTGBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 02:01:39 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43340 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbZCTGBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 02:01:38 -0400
Date: Fri, 20 Mar 2009 11:31:28 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: paulmck@linux.vnet.ibm.com, Arjan van de Ven <arjan@infradead.org>,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: Question about usage of RCU in the input layer
Message-ID: <20090320060128.GC6167@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20090318215812.15496a86@infradead.org> <20090319085628.GA6167@in.ibm.com> <20090319071841.63334eff@infradead.org> <20090320020750.GA6807@linux.vnet.ibm.com> <20090319202032.4c971d92@infradead.org> <20090320044541.GE6807@linux.vnet.ibm.com> <49C3296B.1020209@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49C3296B.1020209@cosmosbay.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 06:28:11AM +0100, Eric Dumazet wrote:
> Paul E. McKenney a écrit :
> Hmm... point is to make linux boot as fast as possible, so ...
> 
> Use a special variant of udelay() in offending drivers that make appropriate
> RCU call to increment quiescent state ?

It may not be safe to do this it is in a RCU read-side critical section.

Thanks
Dipankar
