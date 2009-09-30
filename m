Return-Path: <linux-kernel-owner+w=401wt.eu-S1753052AbZI3Gt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbZI3Gt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 02:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZI3Gt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 02:49:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbZI3Gt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 02:49:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: "H. Peter Anvin" <hpa@zytor.com>, Arjan van de Ven <arjan@infradead.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, mingo@elte.hu,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-api@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [RFC][v7][PATCH 8/9]: Define clone2() syscall
In-Reply-To: Linus Torvalds's message of  Tuesday, 29 September 2009 15:11:03 -0700 <alpine.LFD.2.01.0909291501530.6996@localhost.localdomain>
X-Fcc: ~/Mail/linus
References: <20090924165548.GA16586@us.ibm.com>
	<20090924170308.GH16989@us.ibm.com>
	<200909242343.59903.arnd@arndb.de>
	<20090925082346.GB4436@localdomain>
	<20090925105632.GG12824@hawkmoon.kerlabs.com>
	<20090929180537.GD4625@us.ibm.com>
	<20090929184023.532DF34@magilla.sf.frob.com>
	<4AC255A4.4030002@zytor.com>
	<20090929210207.247b94df@infradead.org>
	<alpine.LFD.2.01.0909291207410.6996@localhost.localdomain>
	<4AC267C7.4070300@zytor.com>
	<alpine.LFD.2.01.0909291501530.6996@localhost.localdomain>
X-Shopping-List: (1) Jubilant ring cheater-hawks
   (2) Pharmaceutical heterogeneous cards
   (3) Maternity affluent secretions
   (4) Expectant snooze riots
Message-Id: <20090930064839.AB188A3@magilla.sf.frob.com>
Date: Tue, 29 Sep 2009 23:48:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The glibc prototype for clone uses ... and is not a direct map to the
syscall args anyway.  So that would not change for adding more optional
args enabled by certain flags, as it did not change to add the tid pointer
arguments before.  But indeed the library function would have to change to
pass on additional or different args to the existing syscall.


Thanks,
Roland
