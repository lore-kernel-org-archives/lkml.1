Return-Path: <linux-kernel-owner+w=401wt.eu-S1758366AbZFPPNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366AbZFPPNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbZFPPND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:13:03 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:38123 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755051AbZFPPNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:13:02 -0400
Date: Tue, 16 Jun 2009 11:12:58 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Nick Piggin <npiggin@suse.de>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
In-Reply-To: <20090616053609.GB2924@wotan.suse.de>
Message-ID: <alpine.DEB.1.10.0906161110481.26093@gentwo.org>
References: <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com> <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop> <1245059859.23207.16.camel@penberg-laptop> <20090615102737.GA20461@wotan.suse.de> <1245062727.12400.23.camel@pasglop>
 <20090615112355.GB6012@wotan.suse.de> <Pine.LNX.4.64.0906151329310.24256@sister.anvils> <20090616045704.GC28596@wotan.suse.de> <1245130087.12400.82.camel@pasglop> <20090616053609.GB2924@wotan.suse.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009, Nick Piggin wrote:

> There aren't too many significant code simplifications AFAIKS.

The code simplification comes from the ability to run the same code during
boot that is also running when the full system is operational. I thought
the intend of this whole exercise was to avoid special casing as much as
possible and reduce the amount of code specifically duplicated for boot
situations?


