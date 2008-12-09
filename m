Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbYLIQqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbYLIQqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 11:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYLIQq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 11:46:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:4785 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbYLIQq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 11:46:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gsMuh96lYixi0n2idPNQ/kD8FXSRrFKNPXBOXnnAEnxvX0VRJ0Nx5dPETMhx9RKoIk
         0/Y8tblYU7qKs0ogw84bzC7dpCRPobxualmjcsnEKlbSRMqWkaKHxdhtqrZOWwjIlXcX
         CIkyVAHnCLrW6bUX173gQHhKpUa32B8rQlrf0=
Message-ID: <87a5b0800812090846h396523a0kdb2d1ca4b4781851@mail.gmail.com>
Date: Tue, 9 Dec 2008 16:46:27 +0000
From: "Will Newton" <will.newton@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] Performance Counters for Linux, v2
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-arch@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Robert Richter" <robert.richter@amd.com>,
       "Arjan van de Veen" <arjan@infradead.org>,
       "Peter Anvin" <hpa@zytor.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "David Miller" <davem@davemloft.net>,
       "Paul Mackerras" <paulus@samba.org>,
       "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
In-Reply-To: <20081209134636.GA1926@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081208012211.GA23106@elte.hu>
	 <7c86c4470812082237ne58c814s7218cc663f3b49e9@mail.gmail.com>
	 <20081209134636.GA1926@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2008 at 1:46 PM, Ingo Molnar <mingo@elte.hu> wrote:

> Firstly, sampling "at 1msec intervals" or any fixed period is a _very_
> wrong mindset - and cross-sampling counters is a similarly wrong mindset.

If your hardware does not interrupt on overflow I don't think you have
any choice in the matter. I know such hardware is less than ideal but
it exists so it should be supported.
