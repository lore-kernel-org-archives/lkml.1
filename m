Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbYGHJd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbYGHJd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 05:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbYGHJdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 05:33:50 -0400
Received: from ozlabs.org ([203.10.76.45]:37537 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbYGHJdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 05:33:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Johannes Weiner <hannes@saeurebad.de>
Subject: Re: Dangerous code in cpumask_of_cpu?
Date: Tue, 8 Jul 2008 19:33:42 +1000
User-Agent: KMail/1.9.9
Cc: Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org,
       "H. Anvin" <hpa@zytor.com>, Christoph Lameter <clameter@sgi.com>,
       Ingo Molnar <mingo@elte.hu>
References: <200807081816.40623.rusty@rustcorp.com.au> <87myksn587.fsf@saeurebad.de> <87iqvgn4c1.fsf@saeurebad.de>
In-Reply-To: <87iqvgn4c1.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807081933.42594.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 July 2008 18:54:38 Johannes Weiner wrote:
> Johannes Weiner <hannes@saeurebad.de> writes:
> > But then, this code should probably just evaluate to m without this
> > obscure *(&m) construct.
>
> This, however is still possible, no?

Unfortunately this change was specifically made in the changeset I refered to, 
so that the &cpumask_of_cpu() could be passed :(

Cheers,
Rusty.
