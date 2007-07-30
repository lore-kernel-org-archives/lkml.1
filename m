Return-Path: <linux-kernel-owner+w=401wt.eu-S966623AbXG3Q2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966623AbXG3Q2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966431AbXG3Q0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:26:33 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:23078 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966621AbXG3Q0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:26:32 -0400
Subject: Re: [PATCH -rt 7/9] introduce PICK_FUNCTION
From: Daniel Walker <dwalker@mvista.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <1185788368.7197.2.camel@twins>
References: <20070730024534.369897977@mvista.com>
	 <20070730024720.690642602@mvista.com>  <1185788368.7197.2.camel@twins>
Content-Type: text/plain
Date: Mon, 30 Jul 2007 09:16:08 -0700
Message-Id: <1185812168.2636.30.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 11:39 +0200, Peter Zijlstra wrote:
> On Sun, 2007-07-29 at 19:45 -0700, Daniel Walker wrote:
> 
> > +#undef TYPE_EQUAL
> > +#define TYPE_EQUAL(var, type) \
> > +		__builtin_types_compatible_p(typeof(var), type *)
> > +
> 
> If you're going to touch this code, could you perhaps change TYPE_EQUAL
> to do as it says and read like so:
> 
> 	__builtin_types_compatible_p(typeof(var), type)
> 

Yeah that makes sense .. I'll add it to my tree ..

Daniel

