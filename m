Return-Path: <linux-kernel-owner+w=401wt.eu-S1752774AbZHFKea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbZHFKea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 06:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbZHFKea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 06:34:30 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:20637 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbZHFKe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 06:34:29 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by
 tgid  at once
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Menage <menage@google.com>
Cc: Benjamin Blum <bblum@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <6599ad830908060328y21a008c1pc5ed5c27e0ec905d@mail.gmail.com>
References: <2f86c2480908031113y525b6cbdhe418b8a0364c7760@mail.gmail.com>
	 <20090803194555.GA10158@us.ibm.com>
	 <6599ad830908041148h6d3f3e9bxfef9f3eedec0ab6d@mail.gmail.com>
	 <2f86c2480908041214r1f23c1b7q9a25b04e26c92a1a@mail.gmail.com>
	 <6599ad830908041228w67bc6f7fh57e28f244e1923b3@mail.gmail.com>
	 <20090805102057.GT29252@hawkmoon.kerlabs.com>
	 <6599ad830908050911t6f23f810i65fe8fe17f3ee698@mail.gmail.com>
	 <20090805164218.GB26446@hawkmoon.kerlabs.com>
	 <2f86c2480908051701s57120404q475edbedb58cdca1@mail.gmail.com>
	 <20090806095854.GD26446@hawkmoon.kerlabs.com>
	 <6599ad830908060328y21a008c1pc5ed5c27e0ec905d@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 12:34:13 +0200
Message-Id: <1249554853.32113.145.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 03:28 -0700, Paul Menage wrote:

> OK, well if lockdep can't currently handle the "writer takes a lock on
> every thread" model,

I haven't read what this is about, but simply looking at that sentence
makes me want to hit someone with a cluebat. Have you any idea how
expensive that is?



